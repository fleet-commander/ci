#!/bin/bash
#
# Copyright (C) 2016 Red Hat, Inc.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the licence, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, see <http://www.gnu.org/licenses/>.
#
# Author: Oliver Gutiérrez <ogutierrez@redhat.com>

eval `dbus-launch`
export DBUS_SESSION_BUS_ADDRESS

echo "Executing Fleet commander logger"
/usr/libexec/fleet_commander_logger.js -v &

while [ 1 ]
do
    echo "Writing sample dconf keys"
    # GSettings keys
    dconf write /org/gnome/nautilus/preferences/show-directory-item-counts "'never'"
    dconf write /org/gnome/nautilus/preferences/default-sort-order "'size'"
    dconf write /org/gnome/nautilus/preferences/show-hidden-files true
    dconf write /org/gnome/nautilus/preferences/thumbnail-limit 5242880
    # LibreOffice keys
    dconf write /org/libreoffice/key1 "'A'"
    dconf write /org/libreoffice/key2 "'B'"
    dconf write /org/libreoffice/key3 "'C'"
    sleep 5

    echo "Writing sample dconf keys"
    # GSettings keys
    dconf write /org/gnome/nautilus/preferences/show-directory-item-counts "'always'"
    dconf write /org/gnome/nautilus/preferences/default-sort-order "'date'"
    dconf write /org/gnome/nautilus/preferences/show-hidden-files false
    dconf write /org/gnome/nautilus/preferences/thumbnail-limit 2561440
    # LibreOffice keys
    dconf write /org/libreoffice/key1 "'X'"
    dconf write /org/libreoffice/key2 "'Y'"
    dconf write /org/libreoffice/key3 "'Z'"
    sleep 5
done