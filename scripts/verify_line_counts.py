import os
import sys

def check_line_counts(directory="lib", max_lines=100):
    violations = []
    total_checked = 0
    for root, _, files in os.walk(directory):
        for f in files:
            if f.endswith(".dart"):
                total_checked += 1
                path = os.path.join(root, f)
                with open(path, "r", encoding="utf-8") as file:
                    lines = file.readlines()
                non_import = [l for l in lines if not l.strip().startswith("import ")]
                if len(non_import) > max_lines:
                    violations.append((path, len(non_import), len(lines)))
    
    violations.sort(key=lambda x: x[1], reverse=True)
    return violations, total_checked

if __name__ == "__main__":
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "lib"
    violations, total = check_line_counts(target_dir)
    print(f"Checked {total} files in '{target_dir}'.")
    if violations:
        print(f"Found {len(violations)} files with > 100 non-import lines:")
        for path, non_imp, total_lines in violations:
            print(f"  {non_imp} non-import lines (total {total_lines}): {path}")
        sys.exit(1)
    else:
        print("All files are <= 100 non-import lines! SUCCESS!")
        sys.exit(0)
