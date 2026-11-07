import os
import subprocess
import time


outpath = "./outfile"

listed_file = "./mounting/type"


valid = ["Not Present", "Forest", "Mountain", "Foundry"]


current_state = 0

running = True


def write_to_file():
    print(f"Writing {current_state} {valid[current_state]}")
    with open(outpath, "w") as f:
        f.write(valid[current_state])
    return

# dont auto check within x cycles since - if its still detected from ejection
last_valid_count = 0

while running:
    time.sleep(0.5)
    
    result = subprocess.run("lsblk | grep '1.4M'", capture_output=True, shell=True)
    print(result)
    
    drive_present = result.returncode == 0
    print(drive_present)
    if not drive_present:
        last_valid_count = 0
        if current_state != 0:
            current_state = 0
            write_to_file()
        # no need to rewrite to file 
        continue
    else:
        path = result.stdout[0:3].decode()
        assert 'sd' in path
        assert len(path) == 3
        print(path)
        # file present
        if last_valid_count != 0:
            print("skipping")
            last_valid_count -= 1
            continue 
        # ok actually mount the filesystem and read it
        try:
            result = subprocess.run(f"mkdir -p ./mounting && timeout 10 mount /dev/{path} ./mounting", shell=True, capture_output=True, timeout=10)
            print(result)
            assert result.returncode == 0
        except (subprocess.TimeoutExpired, AssertionError) as e:
            print("Timed out")
            last_valid_count = 0
            current_state = 0
            write_to_file()
            continue
        try:
            with open(listed_file) as f:
                out = f.read().strip()
                if out not in valid:
                    print(out)
                    print("not valid")
                    break
                cur = valid.index(out)
                if cur != current_state:
                    current_state = cur 
                    write_to_file()
                os.fsync(f.fileno())
        except Exception as e:
            print(e)
            last_valid_count = 0
            current_state = 0
            write_to_file()
            time.sleep(1)
            continue
        success = False
        for i in range(0, 5):
            print("unmounting")
            try:
                result = subprocess.run("umount ./mounting", shell=True, capture_output=True, timeout=5)
                print(result)
                if result.returncode == 0:
                    success = True
                    break
            except subprocess.TimeoutExpired as e:
                print("Timed out")
                last_valid_count = 0
                current_state = 0
                write_to_file()
                break
            time.sleep(0.5)
        assert success
        last_valid_count = 10
        
        # break
        
