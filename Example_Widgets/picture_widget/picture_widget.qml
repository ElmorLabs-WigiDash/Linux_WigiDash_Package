import QtQuick 2.12
import QtQuick.Window 2.12


Rectangle {
    id: myrect
    color: "black"
    //make sure you implement the required properties and functions that the main app expects, required start...
    property int virtual_wigi_width: 1024
    property int virtual_wigi_height: 592
    property int widget_width_ratio: 5
    property int widget_height_ratio: 4
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
        //nothing to do
    }
    function pause_task()
    {
        routine_timer.running=false;
    }
    Timer {
        id: routine_timer
        interval: 100; running: false; repeat: true;
        onTriggered: {
            //nothing to do
        }
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
            picture1=!picture1;
            update_pending=true;
            break;
        default:
            break;

        }
    }
    //required end

    property bool picture1: true
    Item {
        id : gallery
        width: (virtual_wigi_width*widget_width_ratio)/5
        height: (virtual_wigi_height*widget_height_ratio)/4

        Item {
            anchors.centerIn: parent
            width: (virtual_wigi_width*widget_width_ratio)/5
            height: (virtual_wigi_height*widget_height_ratio)/4

            Image { id: pic1; source: "content/pic1.jpg";
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                visible: picture1 == true
            }
            Image { id: pic2; source: "content/pic2.jpg";
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                visible: picture1 == false
            }

        }
    }
    Component.onCompleted: {
        //do your initialization here
    }

}

