#
# Qmake file for Mixxx.
#
# (C) 2002-2004 Tue Haste Andersen <haste@diku.dk>
#
# Unix dependency code and configure script by Gianluca Romanin. See included
# files for copyright details.
#

#
# Options, and path to libraries
#

# Include for unix dependencies. (19/12/2003, J_Zar)
unix:!macx:include( main.qbas )

# Path to Macintosh libraries
macx:MACLIBPATH = ../../mixxx-maclib

# Path to Windows libraries
win32:WINLIBPATH = ../../mixxx-winlib

# Path to ASIO SDK
ASIOSDK_DIR   = $$WINLIBPATH/asiosdk2

#
# End of options
#

# PortAudio
DEFINES += __PORTAUDIO__
SOURCES += playerportaudio.cpp
HEADERS += playerportaudio.h
PORTAUDIO_DIR = ../lib/portaudio-v18
INCLUDEPATH += $$PORTAUDIO_DIR/pa_common
HEADERS += $$PORTAUDIO_DIR/pa_common/portaudio.h
unix {
SOURCES += $$PORTAUDIO_DIR/pa_common/pa_lib.c $$PORTAUDIO_DIR/pa_common/pa_convert.c
HEADERS += $$PORTAUDIO_DIR/pa_common/pa_host.h
unix:!macx:SOURCES += $$PORTAUDIO_DIR/pablio/ringbuffer.c $$PORTAUDIO_DIR/pa_unix_oss/pa_unix.c $$PORTAUDIO_DIR/pa_unix_oss/pa_unix_oss.c
unix:!macx:HEADERS += $$PORTAUDIO_DIR/pablio/ringbuffer.h $$PORTAUDIO_DIR/pa_unix_oss/pa_unix.h
unix:!macx:INCLUDEPATH += $$PORTAUDIO_DIR/pa_unix_oss
macx:SOURCES += $$PORTAUDIO_DIR/pablio/ringbuffer.c $$PORTAUDIO_DIR/pa_mac_core/pa_mac_core.c
macx:LIBS += -framework CoreAudio -framework AudioToolbox
macx:INCLUDEPATH += $$PORTAUDIO_DIR/pa_mac_core $$PORTAUDIO_DIR/pablio 
}
win32 {
    message("Compiling with PortAudio/WMME drivers")
    LIBS += winmm.lib PAStaticWMME.lib
}

# RTAudio (Windows DirectSound)
win32 {
    message("Compiling with RtAudio/DirectSound drivers")
    DEFINES += __RTAUDIO__ __WINDOWS_DS__
    RTAUDIO_DIR = ../lib/rtaudio
    INCLUDEPATH += $$RTAUDIO_DIR
    HEADERS += playerrtaudio.h $$RTAUDIO_DIR/RtAudio.h $$RTAUDIO_DIR/RtError.h
    SOURCES += playerrtaudio.cpp $$RTAUDIO_DIR/RtAudio.cpp
    LIBS += dsound.lib
}

# ASIO (Windows)
#win32 {
#    DEFINES += __ASIO__
#    SOURCES += playerasio.cpp $$ASIOSDK_DIR/common/asio.cpp $$ASIOSDK_DIR/host/asiodrivers.cpp $$ASIOSDK_DIR/host/pc/asiolist.cpp
#    HEADERS += playerasio.h $$ASIOSDK_DIR/common/asio.h $$ASIOSDK_DIR/host/asiodrivers.h $$ASIOSDK_DIR/host/pc/asiolist.h
#    INCLUDEPATH += $$ASIOSDK_DIR/common $$ASIOSDK_DIR/host $$ASIOSDK_DIR/host/pc
#}

# RTAudio (Linux ALSA)
#unix:!macx {
#    DEFINES += __RTAUDIO__ __LINUX_ALSA__
#    RTAUDIO_DIR = ../lib/rtaudio
#    INCLUDEPATH += $$RTAUDIO_DIR
#    HEADERS += playerrtaudio.h $$RTAUDIO_DIR/RtAudio.h $$RTAUDIO_DIR/RtError.h
#    SOURCES += playerrtaudio.cpp $$RTAUDIO_DIR/RtAudio.cpp
#    LIBS += -lasound 
#}

# OSS Midi (Working good, Linux specific)
unix:!macx:SOURCES += midiobjectoss.cpp
unix:!macx:HEADERS += midiobjectoss.h
unix:!macx:DEFINES += __OSSMIDI__

# Windows MIDI
win32:SOURCES += midiobjectwin.cpp
win32:HEADERS += midiobjectwin.h
win32:DEFINES += __WINMIDI__

# CoreMidi (Mac OS X)
macx:SOURCES += midiobjectcoremidi.cpp
macx:HEADERS += midiobjectcoremidi.h
macx:DEFINES += __COREMIDI__
macx:LIBS    += -framework CoreMIDI -framework CoreFoundation

# ALSA PCM (Not currently working, Linux specific)
#SOURCES += playeralsa.cpp
#HEADERS += playeralsa.h
#DEFINES += __ALSA__
#unix:LIBS += -lasound

# ALSA MIDI (Not currently working, Linux specific)
#SOURCES += midiobjectalsa.cpp
#HEADERS += midiobjectalsa.h
#DEFINES  += __ALSAMIDI__

# Visuals
SOURCES += wvisualsimple.cpp wvisualwaveform.cpp visual/visualbackplane.cpp visual/texture.cpp visual/visualbox.cpp visual/visualbuffer.cpp visual/visualbuffersignal.cpp visual/visualbuffersignalhfc.cpp visual/visualbuffermarks.cpp visual/visualchannel.cpp visual/visualcontroller.cpp visual/visualdisplay.cpp visual/visualdisplaybuffer.cpp visual/light.cpp visual/material.cpp visual/picking.cpp visual/pickable.cpp visual/visualobject.cpp
HEADERS += wvisualsimple.h wvisualwaveform.h visual/visualbackplane.h  visual/texture.h visual/visualbox.h visual/visualbuffer.h visual/visualbuffersignal.h visual/visualbuffersignalhfc.h visual/visualbuffermarks.h visual/visualchannel.h visual/visualcontroller.h visual/visualdisplay.h visual/visualdisplaybuffer.h visual/light.h visual/material.h visual/picking.h visual/pickable.h visual/visualobject.h
CONFIG += opengl

# MP3
win32:LIBS += libmad-release.lib libid3tag-release.lib
macx:LIBS += $$MACLIBPATH/lib/libmad.a $$MACLIBPATH/lib/libid3tag.a

# MP3 vbrheadersdk from Xing Technology
INCLUDEPATH += ../lib/vbrheadersdk
SOURCES += ../lib/vbrheadersdk/dxhead.c
HEADERS += ../lib/vbrheadersdk/dxhead.h

# Wave files
win32:SOURCES += soundsourcesndfile.cpp
win32:HEADERS += soundsourcesndfile.h
win32:DEFINES += __SNDFILE__
win32:LIBS += libsndfile.lib
macx:SOURCES += soundsourceaudiofile.cpp
macx:HEADERS += soundsourceaudiofile.h
macx:DEFINES += __AUDIOFILE__
macx:LIBS += $$MACLIBPATH/lib/libaudiofile.a

# Ogg Vorbis
win32:LIBS += vorbisfile_static.lib vorbis_static.lib ogg_static.lib
macx:LIBS += $$MACLIBPATH/lib/libvorbis.a $$MACLIBPATH/lib/libvorbisfile.a $$MACLIBPATH/lib/libogg.a

# PowerMate
SOURCES += powermate.cpp
HEADERS += powermate.h
unix:!macx:SOURCES += powermatelinux.cpp
unix:!macx:HEADERS += powermatelinux.h
win32:SOURCES += powermatewin.cpp
win32:HEADERS += powermatewin.h
win32:LIBS += setupapi.lib

# Mouse
SOURCES += mouse.cpp
HEADERS += mouse.h
unix:!macx:SOURCES += mouselinux.cpp
unix:!macx:HEADERS += mouselinux.h
#win32:SOURCES += mousewin.cpp
#win32:HEADERS += mousewin.h

# Joystick
SOURCES += joystick.cpp
HEADERS += joystick.h
unix:!macx:SOURCES += joysticklinux.cpp
unix:!macx:HEADERS += joysticklinux.h

# KissFFT
KISSFFT_DIR = ../lib/kissfft
SOURCES += $$KISSFFT_DIR/kiss_fft.c $$KISSFFT_DIR/kiss_fftr.c
HEADERS += $$KISSFFT_DIR/kiss_fft.h $$KISSFFT_DIR/kiss_fftr.h $$KISSFFT_DIR/_kiss_fft_guts.h 
INCLUDEPATH += $$KISSFFT_DIR

# Audio scaling
INCLUDEPATH += ../lib/libsamplerate
SOURCES += enginebufferscalesrc.cpp ../lib/libsamplerate/samplerate.c ../lib/libsamplerate/src_linear.c ../lib/libsamplerate/src_sinc.c ../lib/libsamplerate/src_zoh.c
HEADERS += enginebufferscalesrc.h ../lib/libsamplerate/samplerate.h ../lib/libsamplerate/config.h ../lib/libsamplerate/common.h ../lib/libsamplerate/float_cast.h ../lib/libsamplerate/fastest_coeffs.h ../lib/libsamplerate/high_qual_coeffs.h ../lib/libsamplerate/mid_qual_coeffs.h

# Debug plotting through gplot API
#unix:DEFINES += __GNUPLOT__
#unix:INCLUDEPATH += ../lib/gplot
#unix:SOURCES += ../lib/gplot/gplot3.c
#unix:HEADERS += ../lib/gplot/gplot.h

unix:!macx {
  # If Intel compiler is used, set icc optimization flags
  COMPILER = $$system(echo $QMAKESPEC)
  contains(COMPILER, linux-icc) {
    message("Using Intel compiler")
#    QMAKE_CXXFLAGS += -rcd -tpp6 -xiMK # icc pentium III
#    QMAKE_CXXFLAGS += -rcd -tpp7 -xiMKW # icc pentium IV
#    QMAKE_CXXFLAGS += -prof_gen # generete profiling
#    QMAKE_CXXFLAGS += -prof_use # use profiling
    QMAKE_CXXFLAGS += -w1 #-Wall
    # icc Profiling
    QMAKE_CXXFLAGS_DEBUG += -qp -g
    QMAKE_LFLAGS_DEBUG += -qp -g
  }

  # if PREFIX is defined by the user, we use it! ( 19/12/2003, J_Zar)
  isEmpty( PREFIX ) {
    PREFIX = /usr
  }
  UNIX_SHARE_PATH = $${PREFIX}/share/mixxx
  DEFINES += UNIX_SHARE_PATH=\"$$UNIX_SHARE_PATH\"

  SETTINGS_FILE = \".mixxx.cfg\"
  TRACK_FILE = \".mixxxtrack.xml\"
  DEFINES += __LINUX__
}

unix {
  DEFINES += __UNIX__
  INCLUDEPATH += .
  UI_DIR = .ui
  MOC_DIR = .moc
  OBJECTS_DIR = .obj

# GCC Compiler optimization flags
#  QMAKE_CXXFLAGS += -pg -march=pentium3 -O3 -pipe
#  QMAKE_CFLAGS   += -pg -march=pentium3 -O3 -pipe

# gcc Profiling
#QMAKE_CXXFLAGS += -pg
#QMAKE_LFLAGS += -pg
}

win32 {
  DEFINES += __WIN__
  INCLUDEPATH += $$WINLIBPATH ../lib .
  QMAKE_CXXFLAGS += -GX
  QMAKE_LFLAGS += /VERBOSE:LIB /LIBPATH:$$WINLIBPATH /NODEFAULTLIB:library /NODEFAULTLIB:libcd /NODEFAULTLIB:libcmt /NODEFAULTLIB:libc
  SETTINGS_FILE = \"mixxx.cfg\"
  TRACK_FILE = \"mixxxtrack.xml\"
  RC_FILE = mixxx.rc
}

macx {
  DEFINES += __MACX__
  INCLUDEPATH += $$MACLIBPATH/include
  LIBS += -lz -framework Carbon -framework QuickTime
  SETTINGS_FILE = \"mixxx.cfg\"
  TRACK_FILE = \"mixxxtrack.xml\"
  RC_FILE = icon.icns
  QMAKE_CXXFLAGS += -O3 -faltivec -mtune=G4 -mcpu=G4 -mdynamic-no-pic -funroll-loops -ffast-math -fstrict-aliasing
  QMAKE_CFLAGS += -O3 -faltivec -mtune=G4 -mcpu=G4 -mdynamic-no-pic -funroll-loops -ffast-math -fstrict-aliasing
  QMAKE_LFLAGS += -O3 -faltivec -mtune=G4 -mcpu=G4 -mdynamic-no-pic -funroll-loops -ffast-math -fstrict-aliasing
}

# Install-phase for a traditional 'make install'
unix {

    # skins... (copy all)
   skino.path = $${UNIX_SHARE_PATH}/skins/outline
   skino.files = skins/outline/*
   skinoc.path = $${UNIX_SHARE_PATH}/skins/outlineClose
   skinoc.files = skins/outlineClose/*
   skinos.path = $${UNIX_SHARE_PATH}/skins/outlineSmall
   skinos.files = skins/outlineSmall/*
   skint.path = $${UNIX_SHARE_PATH}/skins/traditional
   skint.files = skins/traditional/*

    # midi conf... (copy all)
   midi.path = $${UNIX_SHARE_PATH}/midi
   midi.files = midi/*

    # keyboard conf... (copy all)
   keyb.path = $${UNIX_SHARE_PATH}/keyboard
   keyb.files = keyboard/*

    # doc files...
   readme.path = $${PREFIX}/share/doc/mixxx-1.3
   readme.files = ../README
   licence.path = $${PREFIX}/share/doc/mixxx-1.3
   licence.files = ../LICENSE
   copying.path = $${PREFIX}/share/doc/mixxx-1.3
   copying.files = ../COPYING
   manual.path = $${PREFIX}/share/doc/mixxx-1.3
   manual.files = ../Mixxx-Manual.pdf


    # binary...
   TARGET = mixxx
   target.path = $${PREFIX}/bin

    # finally adding what we wanna install...
   INSTALLS += skino skinoc skinos skint midi keyb readme licence copying manual target
}


FORMS	= dlgprefsounddlg.ui dlgprefmididlg.ui dlgprefplaylistdlg.ui dlgprefcontrolsdlg.ui

SOURCES += mixxxmenuplaylists.cpp trackplaylistlist.cpp mixxxkeyboard.cpp configobject.cpp fakemonitor.cpp controlobjectthread.cpp controlobjectthreadwidget.cpp controlobjectthreadmain.cpp controlevent.cpp controllogpotmeter.cpp controlobject.cpp controlnull.cpp controlpotmeter.cpp controlpushbutton.cpp controlttrotary.cpp controlbeat.cpp dlgpreferences.cpp dlgprefsound.cpp dlgprefmidi.cpp dlgprefplaylist.cpp dlgprefcontrols.cpp enginebuffer.cpp enginebufferscale.cpp enginebufferscalelinear.cpp engineclipping.cpp enginefilterblock.cpp enginefilteriir.cpp engineobject.cpp enginepregain.cpp enginevolume.cpp main.cpp midiobject.cpp midiobjectnull.cpp mixxx.cpp mixxxview.cpp player.cpp playerproxy.cpp soundsource.cpp soundsourcemp3.cpp soundsourceoggvorbis.cpp monitor.cpp enginechannel.cpp enginemaster.cpp wwidget.cpp wpixmapstore.cpp wnumber.cpp wnumberpos.cpp wnumberrate.cpp wnumberbpm.cpp wknob.cpp wdisplay.cpp wvumeter.cpp wpushbutton.cpp wslidercomposed.cpp wslider.cpp wtracktable.cpp wtracktableitem.cpp enginedelay.cpp engineflanger.cpp enginespectralfwd.cpp mathstuff.cpp readerextract.cpp readerextractwave.cpp readerextracthfc.cpp readerextractbeat.cpp readerevent.cpp rtthread.cpp windowkaiser.cpp probabilityvector.cpp reader.cpp trackinfoobject.cpp enginevumeter.cpp peaklist.cpp rotary.cpp
HEADERS += mixxxmenuplaylists.h trackplaylistlist.h mixxxkeyboard.h configobject.h fakemonitor.h controlobjectthread.h controlobjectthreadwidget.h controlobjectthreadmain.h controlevent.h controllogpotmeter.h controlobject.h controlnull.h controlpotmeter.h controlpushbutton.h controlttrotary.h controlbeat.h defs.h dlgpreferences.h dlgprefsound.h dlgprefmidi.h dlgprefplaylist.h dlgprefcontrols.h enginebuffer.h enginebufferscale.h enginebufferscalelinear.h engineclipping.h enginefilterblock.h enginefilteriir.h engineobject.h enginepregain.h enginevolume.h midiobject.h midiobjectnull.h mixxx.h mixxxview.h player.h playerproxy.h soundsource.h soundsourcemp3.h soundsourceoggvorbis.h monitor.h enginechannel.h enginemaster.h wwidget.h wpixmapstore.h wnumber.h wnumberpos.h wnumberrate.h wnumberbpm.h wknob.h wdisplay.h wvumeter.h wpushbutton.h wslidercomposed.h wslider.h wtracktable.h wtracktableitem.h enginedelay.h engineflanger.h enginespectralfwd.h mathstuff.h readerextract.h readerextractwave.h readerextracthfc.h readerextractbeat.h readerevent.h rtthread.h windowkaiser.h probabilityvector.h reader.h trackinfoobject.h enginevumeter.h peaklist.h rotary.h

# New track code:
SOURCES += track.cpp trackcollection.cpp trackplaylist.cpp xmlparse.cpp wtreeview.cpp wtreeitem.cpp wtreeitemfile.cpp wtreeitemdir.cpp wtreeitemplaylist.cpp wtreeitemplaylistroot.cpp
HEADERS += track.h trackcollection.h trackplaylist.h xmlparse.h wtreeview.h wtreeitem.h wtreeitemfile.h wtreeitemdir.h wtreeitemplaylist.h wtreeitemplaylistroot.h

# Track importer
SOURCES += trackimporter.cpp parser.cpp parserpls.cpp parserm3u.cpp
HEADERS += trackimporter.h parser.h parserpls.h parserm3u.h

# Socket
SOURCES += mixxxsocketserver.cpp mixxxsocketclient.cpp #mixxxsocketcli.cpp
HEADERS += mixxxsocketserver.h mixxxsocketclient.h #mixxxsocket.cli.h

IMAGES += icon.png
DEFINES += SETTINGS_FILE=$$SETTINGS_FILE TRACK_FILE=$$TRACK_FILE
unix:TEMPLATE = app
win32:TEMPLATE = vcapp
CONFIG += qt thread warn_off release
DEFINES += QT_NO_CHECK
#CONFIG += qt thread warn_on debug
DBFILE = mixxx.db
LANGUAGE = C++
