#!/usr/bin/env python
from dbus import SessionBus, Interface
from dbus.exceptions import DBusException
from os import environ
from sys import version_info
import subprocess

spotify = None
try:
    bus = SessionBus()
    spotify = bus.get_object(
        "org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2"
    )
except DBusException:
    exit()

# Handle clicks to the i3block
if block_button := environ.get("BLOCK_BUTTON"):
    control_iface = Interface(spotify, "org.mpris.MediaPlayer2.Player")
    if block_button == "1":
        control_iface.Previous()

    elif block_button == "2":
        control_iface.PlayPause()

    elif block_button == "3":
        control_iface.Next()

    elif block_button == "3":
        control_iface.Next()

    elif block_button == "4":
        subprocess.call(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"])

    elif block_button == "5":
        subprocess.call(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"])

# Get information from spotify object
spotify_iface = Interface(spotify, "org.freedesktop.DBus.Properties")
props = spotify_iface.Get("org.mpris.MediaPlayer2.Player", "Metadata")

print(f'{props["xesam:artist"][0]} – {props["xesam:title"]}')
