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

echo "Executing Fleet commander logger ..."
/usr/libexec/fleet_commander_logger.js -v &

sleep 5

eval `dbus-launch`
export DBUS_SESSION_BUS_ADDRESS

echo "Writing sample dconf keys ..."
dconf write /org/gnome/nautilus/preferences/show-directory-item-counts "'never'"
dconf write /org/gnome/nautilus/preferences/default-sort-order "'size'"
dconf write /org/gnome/nautilus/preferences/show-hidden-files true
dconf write /org/gnome/nautilus/preferences/thumbnail-limit 5242880

echo "All done! Modified keys:"
echo " - /org/gnome/nautilus/preferences/show-directory-item-counts set to never"
echo " - /org/gnome/nautilus/preferences/default-sort-order set to size"
echo " - /org/gnome/nautilus/preferences/show-hidden-files set to true"
echo " - /org/gnome/nautilus/preferences/thumbnail-limit set to 5242880"