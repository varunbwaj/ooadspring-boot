import pathlib, sys
module_dir = pathlib.Path(__file__).parent.parent
sys.path.append(str(module_dir))

print(sys.path)
print(module_dir)