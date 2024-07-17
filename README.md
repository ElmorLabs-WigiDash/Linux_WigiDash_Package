# Linux_WigiDash_Package
A hobbyist port to Linux

Even though its built statically with QT 5.15.2, there are some dependencies such as mesa and libegl1 so if you dont want to install QT then try to run it to see what packages are missing.

run as root, sudo ./wigi_linux

3 example widgets in Example_Widgets Folders. Widgets are simply implemented via qml files without need for compiling. More complicated logic can be implemented with plugin such as the cpu_vft_widget example. This widget needs Secure Boot Disabled in BIOS to access the hardware.
