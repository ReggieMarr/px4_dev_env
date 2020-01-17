import argparse
import json
def get_arguments():
    parser = argparse.ArgumentParser(prog='Print Specific Fils',
    description="prints files that are compiled, requires that a \
             compile_commands.json file exists")
    parser.add_argument("-v", help='Prints files as a vertical\
            list', action='store_true')
    return parser.parse_args()


def print_compiled_files(vertical_list):
    file_name = "./compile_commands.json"

    with open(file_name, "r") as read_file:
        commands_json  = json.load(read_file)

    file_string = ""
    for idx in commands_json:
        if "file" in idx:
            if(vertical_list):
                print (idx["file"])
            file_string += idx["file"] + " "
        else:
            for json_obj in idx:
                print (json_obj["files"])
    if (not vertical_list):
        print (file_string)

def main():
    args = get_arguments()
    print_compiled_files(args.v)

if __name__ == "__main__":
    main()
