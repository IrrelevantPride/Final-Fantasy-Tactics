import numpy as np
import xml.etree.ElementTree as et
from os import path, listdir

def create_xml():
    patches = et.Element("Patches")
    patch = et.SubElement(patches, "Patch", name="SCUS Modifications")
    name = "Test Patch"
    for file in listdir("SCUS_942_21"):
        if not file.endswith(".asm"): continue
        with open(path.join("SCUS_942_21", file)) as f:
            string_offset = f.readline().strip(".org \n")
        offset = get_offset(string_offset)
        label = file.replace(" ", "_")
        label = label.replace(".asm", "")
        location = et.SubElement(
            patch,
            "Location",
            file = "SCUS_942_21",
            offset = offset,
            offsetMode = "RAM",
            mode = "ASM",
            label = label,
            inputFile = file
        )
        
        if not offset:
            location.attrib.pop("offset")
            location.attrib.pop("offsetMode")

    tree = et.ElementTree(patches)
    et.indent(tree, space="\t", level = 0)
    tree.write(name + ".xml", encoding="utf-8", xml_declaration = True)


def get_offset(string_offset):
    try:
        offset = np.uint32(int(string_offset, 16))
        offset &= 0x7FFFFFFF
        offset = str(hex(offset))
        return offset.replace("0x", "")
    except:
        return False

if __name__ == "__main__":
    create_xml()