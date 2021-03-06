#!/usr/bin/env python3

import dbus
import os
import sys
import subprocess


try:
    bus = dbus.SessionBus()
    spotify = bus.get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")

    if os.environ.get('BLOCK_BUTTON'):
        control_iface = dbus.Interface(spotify, 'org.mpris.MediaPlayer2.Player')
        if (os.environ['BLOCK_BUTTON'] == '1'):
            control_iface.Previous()
        elif (os.environ['BLOCK_BUTTON'] == '2'):
            control_iface.PlayPause()
        elif (os.environ['BLOCK_BUTTON'] == '3'):
            control_iface.Next()
        elif (os.environ['BLOCK_BUTTON'] == '3'):
            control_iface.Next()
        elif (os.environ['BLOCK_BUTTON'] == '4'):
            subprocess.call(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"])
        elif (os.environ['BLOCK_BUTTON'] == '5'):
            subprocess.call(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"])

    spotify_iface = dbus.Interface(spotify, 'org.freedesktop.DBus.Properties')
    props = spotify_iface.Get('org.mpris.MediaPlayer2.Player', 'Metadata')

    if (sys.version_info > (3, 0)):
        print(str(props['xesam:artist'][0]) + " - " + str(props['xesam:title']))
    else:
        print("<span color='#2ebd59'></span>" + props['xesam:artist'][0] + " - " + props['xesam:title'])
        # removed _after_ print .encode('utf-8')
    exit
except dbus.exceptions.DBusException:
    exit
