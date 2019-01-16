import glob
import os
import re

def main():
    markdown_filenames = glob.glob("*.md")
    print_graph(markdown_filenames)

def print_graph(markdown_filenames):
    print("digraph {")
    print("    graph [rankdir=LR]")
    print("    node [shape=box];")
    for filename in markdown_filenames:
        if filename[0] == "_":
            continue
        page_name = get_page_name(filename)
        print("    \"{0}\" [URL=\"{1}\"];".format(page_name, page_name + ".html"))
    print("    node [shape=box,color=red];")
    page_names = [get_page_name(filename) for filename in markdown_filenames]
    for filename in markdown_filenames:
        if filename[0] == "_":
            continue
        page_name = get_page_name(filename)
        for link in get_links(filename):
            link_name = os.path.splitext(link)[0]
            if link_name[0] == "_":
                continue
            edge_attributes = ""
            if link_name not in page_names:
                edge_attributes = "[color=red]"
            print("    \"{0}\" -> \"{1}\" {2};".format(
                      page_name,
                      link_name,
                      edge_attributes))
    print("}")

def get_page_name(filename):
    return os.path.splitext(filename)[0]

def get_links(filename):
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
