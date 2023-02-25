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
        et.SubElement(
            patch,
            "Location",
            file = "SCUS_942_21",
            offset = offset,
            mode = "ASM",
            offsetMode = "RAM",
            label = label,
            inputFile = file
        )
    tree = et.ElementTree(patches)
    et.indent(tree, space="\t", level = 0)
    tree.write(name + ".xml", encoding="utf-8", xml_declaration = True)


def get_offset(string_offset):
    offset = np.uint32(int(string_offset, 16))
    offset &= 0x7FFFFFFF
    offset = str(hex(offset))
    return offset.replace("0x", "")

if __name__ == "__main__":
    create_xml()