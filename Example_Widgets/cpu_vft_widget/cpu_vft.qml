import QtQuick 2.12
import QtQuick.Window 2.12

Rectangle {
    id: myrect
    color: "black"
    border.color: "yellow"
    border.width: 2
    //make sure you implement the required properties and functions that the main app expects, required start...
    property int virtual_wigi_width: 1024
    property int virtual_wigi_height: 592
    property int widget_width_ratio: 1
    property int widget_height_ratio: 1
    property int page: 0
    property int myid: 0
    property bool update_pending: true
    property string plugin_file: "wigilib.so"
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
        interval: 1000; running: false; repeat: true;
        onTriggered: {
            send_data();
            update_pending=true;
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
            if(current_corenum>=(totalcores-1))
                current_corenum=0;
            else
                current_corenum++;
            update_pending=true;
            break;
        default:
            break;

        }
    }
    //required end

    property bool send_data_pending: false;
    property int numcores: 1
    property int numthreads: 1
    property int num_smallcores: 0
    property int num_bigcores: 1
    property int totalcores: 1
    property var hyperthreaded:[]
    property var efficiency_Class:[]
    property bool initialized: false

    property int current_corenum:0
    property int max_cpus_needed: 512

    property var freq_vec:[]
    property var vid_vec:[]
    property var temp_vec:[]

    function send_data()
    {
        //widget_sending_data(const QVariant &data, int pager, int iden, int len,int type);
        var myList = [];
        var len=1;
        var type=0;//0 for integer
        if(!initialized)
        {
            myList.push(1);//1 is my code to my lib for init
        }
        else
        {
            myList.push(2);//2 is my code to my lib for get freq vied temp
        }
        my_controller.widget_sending_data(myList, page, myid, len, type);
    }

    function toByte(value) {
        // Ensure the value falls within the byte range (0-255)
        return Math.max(0, Math.min(255, value));
    }

    function receive_data(lstvar, len, type){
        if(!initialized)
        {
            /* fill in the struct
              #define MAX_CPUS_NEEDED 512
                typedef struct _CPU_CORE_STRUCT{
                    int threads;
                    int Efficiency_Class[max_cpus_needed];
                    int num_smallcores;
                    int num_bigcores;
                    int Hyperthreaded[max_cpus_needed];
                }__attribute__((packed)) CPU_CORE_STRUCT;*/
            numthreads=lstvar[0];
            //console.log(numthreads);
            var index=1;
            while(index<(max_cpus_needed+1))
            {
                efficiency_Class.push(lstvar[index]);
                index++;
            }
            num_smallcores=lstvar[index];
            //console.log(num_smallcores);
            index++;
            num_bigcores=lstvar[index];
            //console.log(num_bigcores);
            index++;
            for(var i=0;i<max_cpus_needed;i++)
            {
                hyperthreaded.push(lstvar[index]);
                index++;
            }
            totalcores=num_smallcores+num_bigcores;
            for(var i=0;i<totalcores;i++)
            {
                freq_vec.push(0);
                vid_vec.push(0);
                temp_vec.push(0);
            }
            initialized=true;
        }
        else
        {
            var index=0;
            for(var i=0;i<totalcores;i++)
            {
                freq_vec[i]=lstvar[index];
                //console.log(freq_vec[i]);
                index++;
                vid_vec[i]=lstvar[index];
                index++;
                temp_vec[i]=lstvar[index];
                index++;
            }
            current_freq=freq_vec[current_corenum];
            current_vid=vid_vec[current_corenum];
            current_vid/=1000.0;
            current_temp=temp_vec[current_corenum];
        }
    }
    property int current_freq: 0
    property double current_vid: 0
    property int current_temp: 0
    function isBrightEnough(color) {
        // Extract the RGB components from the hex color
        var r = parseInt(color.slice(1, 3), 16);
        var g = parseInt(color.slice(3, 5), 16);
        var b = parseInt(color.slice(5, 7), 16);

        // Calculate the brightness
        // Using the luminance formula: 0.299*R + 0.587*G + 0.114*B
        var brightness = 0.299 * r + 0.587 * g + 0.114 * b;

        // Return true if brightness is above a certain threshold, e.g., 60
        return brightness > 60;
    }
    function getRandomColor() {
        var letters = "0123456789ABCDEF";
        var color;
        do {
            color = "#";
            for (var i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
        } while (!isBrightEnough(color));
        return color;
    }
    property string sharedColor: getRandomColor();

    Text {
        id: core_text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.margins: 10
        color: sharedColor//"lightpink"
        wrapMode: Text.WordWrap
        font.pointSize: 20
        font.family: "Verdana"
        font.bold: true
        text: {
            var coreStr = "Core";
            if (totalcores > 1) {
                if (num_smallcores > 0) {
                    if (efficiency_Class[current_corenum] === 0) {
                        coreStr = "ECore";
                    }
                    else {
                        coreStr = "PCore";
                    }
                }
            }
            coreStr + Number(current_corenum).toLocaleString();
        }
    }

    Text {
        id: freq_text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: core_text.bottom
        anchors.topMargin: 3
        color: sharedColor//"lightpink"
        wrapMode: Text.WordWrap
        font.pointSize: 18
        font.family: "Arial"
        font.italic: true
        text: {
            Number(current_freq).toLocaleString()+"MHz";
        }
    }

    Text {
        id: vid_text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: freq_text.bottom
        anchors.topMargin: 1
        color: sharedColor//"lightpink"
        wrapMode: Text.WordWrap
        font.pointSize: 18
        font.family: "Arial"
        font.italic: true
        text: {
            Number(current_vid).toLocaleString()+"V";
        }
    }

    Text {
        id: temp_text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: vid_text.bottom
        anchors.topMargin: 1
        color: sharedColor//"lightpink"
        wrapMode: Text.WordWrap
        font.pointSize: 18
        font.family: "Arial"
        font.italic: true
        text: {
            Number(current_temp).toLocaleString()+"C";
        }
    }


    Component.onCompleted: {
        //do your initialization here
    }

}

