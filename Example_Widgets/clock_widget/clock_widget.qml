import QtQuick 2.12
import QtQuick.Window 2.12


Rectangle {
    id: myrect
    color: "grey"
    //make sure you implement the required properties and functions that the main app expects, required start...
    property int virtual_wigi_width: 1024
    property int virtual_wigi_height: 592
    property int widget_width_ratio: 1
    property int widget_height_ratio: 2
    property int page: 0
    property int myid: 0
    property bool update_pending: true
    property string plugin_file: ""//this widget requires no plugin/lib to run
    width: (virtual_wigi_width*widget_width_ratio)/5
    height: (virtual_wigi_height*widget_height_ratio)/4
    enum TouchAction {
        None, SingleTap, DoubleTap, LongTap, DragStart, DragEnd, SwipeLeft, SwipeRight, SwipeUp, SwipeDown
    }
    function start_routine()
    {
        routine_timer.running=true;
    }
    function pause_task()
    {
        routine_timer.running=false;
    }
    Timer {
        id: routine_timer
        interval: 100; running: false; repeat: true;
        onTriggered: timeChanged()
    }
    function clickevent(action, x_pos,y_pos) {
        //console.log("action ",action);
        switch(action)
        {
        case 0:
            break;
        case 1:
        case 2:
        case 3:
            digital=!digital;
            break;
        default:
            break;

        }
    }
    //required end


    property int hours
    property int minutes
    property int seconds
    property bool digital: false
    property string clocktext: ""
    function timeChanged() {
        var date = new Date;
        hours = date.getHours();
        minutes = date.getMinutes();
        seconds = date.getUTCSeconds();
        clocktext=Number(hours)+":"+Number(minutes)+":"+Number(seconds);
        update_pending=true;
    }

    Item {       
        id : clock
        width: (virtual_wigi_width*widget_width_ratio)/5
        height: (virtual_wigi_height*widget_height_ratio)/4

        Item {
            anchors.centerIn: parent
            width: (virtual_wigi_width*widget_width_ratio)/5
            height: (virtual_wigi_height*widget_height_ratio)/4

            Image { id: background; source: "content/clock_day.png"; visible: digital == false}

            Image {
                x: 92.5; y: 27
                source: "content/hour.png"
                visible: digital == false
                transform: Rotation {
                    id: hourRotation
                    origin.x: 7.5; origin.y: 73;
                    angle: (hours * 30) + (minutes * 0.5)
                    Behavior on angle {
                        SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                    }
                }
            }

            Image {
                x: 93.5; y: 17
                source: "content/minute.png"
                visible: digital == false
                transform: Rotation {
                    id: minuteRotation
                    origin.x: 6.5; origin.y: 83;
                    angle: minutes * 6
                    Behavior on angle {
                        SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                    }
                }
            }

            Image {
                x: 97.5; y: 20
                source: "content/second.png"
                visible: digital == false
                transform: Rotation {
                    id: secondRotation
                    origin.x: 2.5; origin.y: 80;
                    angle: seconds * 6
                    Behavior on angle {
                        SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                    }
                }
            }

            Text {
                id: digital_clock
                visible: digital == true
                y: 100; anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                font.family: "Helvetica"
                font.bold: true; font.pixelSize: 40
                style: Text.Raised; styleColor: "black"
                text: clocktext
            }

            Text {
                id: my_label
                y: 210; anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                font.family: "Helvetica"
                font.bold: true; font.pixelSize: 16
                style: Text.Raised; styleColor: "black"
                text: "Time"
            }
        }
    }
    Component.onCompleted: {
        //do your initialization here
    }
}

