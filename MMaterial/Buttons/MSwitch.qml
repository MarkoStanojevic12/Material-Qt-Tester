import QtQuick
import QtQuick.Layouts

import MMaterial

Item{
    id: _switchRoot

    property int size: Size.Grade.M

    property PaletteBasic accent: Theme.primary

    property alias checked: _switch.checked
    property alias customCheckImplementaiton: _switch.customCheckImplementation
    property alias text: _label.text
    property alias label: _label

    implicitWidth: _switch.width + _label.anchors.leftMargin + _label.implicitWidth
    implicitHeight: {
        if(size == Size.Grade.M)
            return Size.pixel20

        return Size.pixel16
    }

    signal clicked

    Checkable{
        id: _switch

        height: parent.height
        width: height * 1.6

        radius: 100

        onClicked: _switchRoot.clicked();

        states: [
            State {
                when: !_switchRoot.enabled
                name: "disabled"
                PropertyChanges { target: _switchRoot; opacity: 0.48 }
                PropertyChanges { target: _switch; color: Theme.main.transparent.p48 }
                PropertyChanges { target: _innerCircle; x: _switchRoot.checked ? _innerCircle.parent.width - _innerCircle.width : 0 }
            },
            State {
                when: _switch.checked
                name: "checked"
                PropertyChanges { target: _switchRoot; opacity: 1 }
                PropertyChanges { target: _switch; color: _switchRoot.accent.main }
                PropertyChanges { target: _innerCircle; x: _innerCircle.parent.width - _innerCircle.width }
            },
            State {
                when: true
                name: "unchecked"
                PropertyChanges { target: _switchRoot; opacity: 1 }
                PropertyChanges { target: _switch; color: Theme.main.transparent.p48 }
                PropertyChanges{ target: _innerCircle; x: 0 }
            }
        ]
        transitions: [
            //scale elastic animation
            Transition {
                from: "unchecked"
                NumberAnimation {
                    target: _innerCircle
                    property: "x"
                    duration: 250
                    easing.type: Easing.OutQuad
                }
                ColorAnimation { target: _switch; duration: 250; easing.type: Easing.InOutQuad }
            },
            Transition {
                from: "checked"
                NumberAnimation {
                    target: _innerCircle
                    property: "x"
                    duration: 250
                    easing.type: Easing.OutQuad
                }
                ColorAnimation { target: _switch; duration: 250; easing.type: Easing.InOutQuad }
            }
        ]

        Item{
            anchors{
                fill: parent
                margins: _switch.height * 0.15
            }

            Rectangle{
                id: _innerCircle

                anchors{
                    top: parent.top
                    bottom: parent.bottom
                }

                width: height

                radius: _switch.radius
                color: Theme.main.p100

                Rectangle{
                    id: _highlight

                    anchors.centerIn: parent

                    height: _switch.mouseArea.containsMouse ? parent.height * 2.7 : 0
                    width: height

                    radius: height
                    visible: height > 0
                    opacity: _switch.mouseArea.pressed ? 0.7 : 1
                    color: _switch.checked ? _switchRoot.accent.transparent.p8 : Theme.action.hover

                    Behavior on height { SmoothedAnimation { duration: 150; easing.type: Easing.InOutQuad} }
                }
            }
        }
    }

    B2{
        id: _label

        anchors{
            left: _switch.right; leftMargin: Size.pixel12
            right: parent.right
        }

        height: parent.height

        visible: text.length > 0
        verticalAlignment: Qt.AlignVCenter
        maximumLineCount: 1
        elide: Text.ElideRight
        wrapMode: Text.NoWrap
    }
}
