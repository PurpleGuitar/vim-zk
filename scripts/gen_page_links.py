import glob
import os
import re

import yaml

def main():
    with open("_metadata.yaml") as infile:
        metadata = yaml.load(infile)
    print_graph(metadata)

def print_graph(metadata):
    print("digraph {")
    print("    graph [rankdir=LR]")
    print("    node [shape=box];")
    for page in metadata:
        if page["pagename"][0] == "_":
            continue
        title = page["pagename"]
        if "title" in page["pagedata"]:
            title = page["pagedata"]["title"]
        print("    \"{0}\" [label=\"{1}\" URL=\"{2}\"];".format(
            page["pagename"], 
            title,
            page["pagename"] + ".html"))
    print("    node [shape=box,color=red];")
    pagenames = [page["pagename"] for page in metadata]
    for page in metadata:
        if page["filename"][0] == "_":
            continue
        for pagelink in page["pagelinks"]:
            if pagelink[0] == "_":
                continue
            edge_attributes = ""
            if pagelink not in pagenames:
                edge_attributes = "[color=red]"
            print("    \"{0}\" -> \"{1}\" {2};".format(
                      page["pagename"],
                      pagelink,
                      edge_attributes))
    print("}")

if __name__ == "__main__":
    main()
