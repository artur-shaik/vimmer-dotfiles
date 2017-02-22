#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
author:     Artur Shaik
source:     http://github.com/artur-shaik/vimmer-dotfiles
description:
    Convert vimwiki files to html with the same structure
"""

import os
import re
import shutil
from optparse import OptionParser

HOME = os.path.expanduser('~')
VIMWIKI_HOME = "%s/vimwiki" % HOME
VIMWIKI_HTML = "%s/vimwiki_html" % HOME
TMP_DIRECTORY = "%s/.tmp" % VIMWIKI_HTML
META = ["CSS:  file://%s/markdown.css\n" % VIMWIKI_HTML, "\n"]
VIMWIKI_EXT = ".md"
MD_CONVERTER = "multimarkdown -f"
OPEN_DEFAULT = "elinks"


class WikiFile():
    def __init__(self, name):
        self.name = name
        slash_index = self.name.rfind("/")
        if slash_index >= 0:
            self.directory = name[:slash_index + 1]
        else:
            self.directory = ''
        self.filename = name[len(self.directory):]
        dot_index = self.filename.rfind(".")
        if dot_index >= 0:
            self.extension = self.filename[dot_index:]
        else:
            self.extension = ''

    def get_html_file(self):
        return "%s.html" % self.filename[:-len(VIMWIKI_EXT)]

    def __str__(self):
        return "[name = %s, directory = %s, filename = %s]" \
            % (self.name, self.directory, self.filename)


def main():
    open_in_browser, browser = parse_args()

    tmp_dir = get_tmp_directory()
    for file in get_wiki_files():
        if os.path.isdir(file):
            continue

        wiki_file = WikiFile(file[len(VIMWIKI_HOME):])

        if wiki_file.extension == VIMWIKI_EXT:
            tmp_file_dir = "%s/%s" % (tmp_dir, wiki_file.directory)
            tmp_file_name = "%s/%s" % (tmp_dir, wiki_file.name)
            write_tmp_file_with_meta(
                    tmp_file_dir, tmp_file_name, fix_wiki_links(file))
            html_file_dir = "%s/%s" % (VIMWIKI_HTML, wiki_file.directory)
            html_file_name = generate_html_file(
                    wiki_file, html_file_dir, tmp_file_name)
            fix_links_in_html(html_file_name)
        else:
            copy_file_html_dir(wiki_file)

    if open_in_browser:
        os.system("%s %s/index.html" % (browser, VIMWIKI_HTML))


def parse_args():
    args_parser = OptionParser()
    args_parser.add_option("-o", "--open", action="store_true")
    args_parser.add_option("-b", "--browser", action="store",
                           type="string", default=OPEN_DEFAULT)
    opt, args = args_parser.parse_args()
    browser = opt.browser
    open_in_browser = opt.open
    return (open_in_browser, browser)


def fix_wiki_links(file):
    new_file_lines = []
    for line in open(file, 'r'):
        for find in re.findall('\[.*\]\((.*)\)', line):
            find = find.strip()
            if not find.startswith('http'):
                if not WikiFile(find).extension:
                    line = line.replace(
                            '(%s)' % find,
                            '(%s%s)' % (find, VIMWIKI_EXT))
        new_file_lines.append(line)
    return new_file_lines


def write_tmp_file_with_meta(tmp_file_dir, tmp_file_name, lines):
    if not os.path.isdir(tmp_file_dir):
        os.makedirs(tmp_file_dir)
    with open(tmp_file_name, 'w') as tmp_file:
        for meta in META:
            tmp_file.write(meta)
        tmp_file.writelines(lines)


def generate_html_file(wiki_file, html_file_dir, tmp_file_name):
    if not os.path.isdir(html_file_dir):
        os.makedirs(html_file_dir)
    html_file_name = "%s/%s" % (
            html_file_dir, wiki_file.get_html_file())
    os.system('%s "%s" > "%s"' % (
        MD_CONVERTER, tmp_file_name, html_file_name))
    return html_file_name


def fix_links_in_html(html_file_name):
    os.system('sed -i -E "s/%s/.html/g" %s' % (
        VIMWIKI_EXT, html_file_name))


def copy_file_html_dir(wiki_file):
    html_file_dir = "%s/%s" % (VIMWIKI_HTML, wiki_file.directory)
    if not os.path.isdir(html_file_dir):
        os.makedirs(html_file_dir)
    shutil.copy("%s/%s" % (VIMWIKI_HOME, wiki_file.name), html_file_dir)


def get_tmp_directory():
    if os.path.isdir(TMP_DIRECTORY):
        shutil.rmtree(TMP_DIRECTORY)
    os.mkdir(TMP_DIRECTORY)
    return TMP_DIRECTORY


def get_wiki_files():
    wiki_files = []
    for root, dirnames, filenames in os.walk(VIMWIKI_HOME):
        for filename in filenames:
            wiki_files.append(os.path.join(root, filename))
    return wiki_files

if __name__ == "__main__":
    main()
