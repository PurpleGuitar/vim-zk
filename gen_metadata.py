import glob
import os
import re
import sys

import yaml

def main():
    filenames = glob.glob("*.md")
    metadata = [extract_metadata(filename) for filename in filenames]
    print(yaml.dump(metadata, default_flow_style=False, indent=4))

def extract_metadata(filename):
    metadata = {}
    metadata["filename"] = filename
    metadata["pagename"] = extract_page_name(filename)
    metadata["pagedata"] = extract_page_metadata(filename)
    metadata["pagelinks"] = [extract_page_name(link) for link in extract_links(filename)]
    return metadata

def extract_page_name(filename):
    return os.path.splitext(filename)[0]

def extract_page_metadata(filename):
    try:
        yaml_text = ""
        with open(filename) as infile:
            # Extract yaml doc
            in_yaml = False
            first_line = True
            for line in infile:
                if line == "---\n":
                    if first_line:
                        in_yaml = True
                    else:
                        break
                else:
                    if in_yaml:
                        yaml_text += line
                    else:
                        break;
                first_line = False
        if yaml_text != "":
            pagedata = yaml.safe_load(yaml_text)
            return pagedata
    except Exception as e:
        eprint(e)
    return {}

def eprint(*args, **kwargs):
    """ Print to error stream """
    print(*args, file=sys.stderr, **kwargs)
    sys.stderr.flush()

def extract_links(filename):
    links = []
    link_pattern = re.compile("\]\(([a-zA-Z0-9\-_]+\.html)\)")
    with open(filename) as in_file:
        for line in in_file:
            match = link_pattern.search(line)
            if match:
                links.append(match.group(1))
    return links

if __name__ == "__main__":
    main()
