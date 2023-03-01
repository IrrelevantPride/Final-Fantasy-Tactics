import json
import xml.etree.ElementTree as et
from os import path, listdir, mkdir
from pathlib import Path
from numpy import uint32
from shutil import copy

def create_xml():
    function_info = load_json("function_info.json")
    patches = et.Element("Patches")
    patch = et.SubElement(patches, "Patch", name="SCUS Modifications")
    name = "Test Patch"

    for gamefile in function_info:
        file = function_info.get(gamefile).pop("location tag")
        for function in function_info[gamefile]:
            location = et.SubElement(
                patch,
                "Location"
            )
            file_name = function_info[gamefile][function].get("file name")
            offset = function_info[gamefile][function].get("offset")
            
            if offset:
                if len(offset) < 2:
                    offset = get_offset(offset)
                    location.attrib["file"] = file
                    location.attrib["offset"] = offset[0]
                else:
                    location.attrib["specific"] = f"{file}: {', '.join(offset)}"
            
            location.attrib["offsetMode"] = "RAM"
            location.attrib["mode"] = "ASM"
            label = file_name.replace(" ", "_")
            label = label.replace(".asm", "")
            location.attrib["label"] = label
            
            if function_info[gamefile][function].get("inline"):
                location.text = f"\n{Path(path.join(gamefile, file_name)).read_text()}"
            else:
                location.attrib["inputFile"] = path.join("...", file, file_name)

    tree = et.ElementTree(patches)
    et.indent(tree, space="\t", level = 0)
    tree.write(name + ".xml", encoding="utf-8", xml_declaration = True)
    save_xml_to_directory(name)

def load_json(file_name):
    json_dict = {}
    try:
        with open(file_name) as json_file:
            json_dict = json.load(json_file)
        
    except FileNotFoundError:
            print(f"Error: {file_name} was not found.")
            
    return json_dict

def get_offset(string_offset):
        offset_list = []
        for offset in string_offset:
            offset = uint32(int(offset, 16))
            offset &= 0x7FFFFFFF
            offset = str(hex(offset))
            offset = offset.replace("0x", "")
            offset_list.append(offset)
        return offset_list

def save_asm_files_to_directory():
    save_directory = "C:\\Users\\nioro\\OneDrive\\Documents\\Final Fantasy Tactics\\FFTPatcher_20220322\\XmlPatches\\PSX"
    function_info = load_json("function_info.json")
    for location in function_info:
        folder_path = path.join(save_directory, location)
        if not path.isdir(folder_path): mkdir(folder_path)
        for file in listdir(location):
            source = path.join(location, file)
            destination = path.join(save_directory, source)
            if path.isfile(source):
                copy(source, destination)

def save_xml_to_directory(xml_file):
    save_directory = "C:\\Users\\nioro\\OneDrive\\Documents\\Final Fantasy Tactics\\FFTPatcher_20220322\\XmlPatches\\PSX"
    xml_file += ".xml"
    if path.isfile(xml_file):
        copy(xml_file, save_directory)

if __name__ == "__main__":
    create_xml()
    save_asm_files_to_directory()