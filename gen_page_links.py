import glob
import os
import re

def main():
    markdown_filenames = glob.glob("*.md")
    print_graph(markdown_filenames)

def print_graph(markdown_filenames):
    page_names = [os.path.splitext(filename)[0] for filename in markdown_filenames]
    print("digraph {")
    print("    node [shape=box];")
    for page_name in page_names:
        print("    {0};".format(page_name))
    print("    node [shape=box,color=red];")
    for filename in markdown_filenames:
        page_name = os.path.splitext(filename)[0]
        for link in get_links(filename):
            link_name = os.path.splitext(link)[0]
            edge_attributes = ""
            if link_name not in page_names:
                edge_attributes = "[color=red]"
            print("    {0} -> {1} {2};".format(
                      page_name,
                      link_name,
                      edge_attributes))
    print("}")

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
