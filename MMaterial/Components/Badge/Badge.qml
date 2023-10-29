import QtQuick 

import "../../Colors"
import "../../Icons"
import "../../Settings"
//change the value of icon.sourceSize.widht / height

Item{
    id: _badge

    property alias icon: _icon
    property var accent: Theme.info //Needs to be PaletteBasic type
    property int type: Badge.Type.Dot

    property int quantity: 1
    property int maxQuantity: 999

    signal clicked

    enum Type { Dot, Number }

    implicitHeight: _icon.height
    implicitWidth: _icon.width

    states: [
        State{
            name: "dot"
            when: _badge.type == Badge.Type.Dot
            PropertyChanges{
                target: _badgeLoader
                sourceComponent: _iconDot
                anchors{
                    bottomMargin: -_icon.height * 0.05
                    leftMargin: -_icon.width * 0.05
                }
            }
        },
        State{
            name: "number"
            when: _badge.type == Badge.Type.Number
            PropertyChanges{
                target: _badgeLoader
                sourceComponent: _iconBadge
                anchors{
                    bottomMargin: -_icon.height * 0.47
                    leftMargin: -_icon.width * 0.5
                }
            }
        }
    ]

    Icon{
        id: _icon

        path: IconList.mail
        sourceSize.height: Size.pixel32
        color: Theme.text.primary
        interactive: true

        onClicked: _badge.clicked()
    }
    Loader{
        id: _badgeLoader

        anchors {
            bottom: _icon.top
            left: _icon.right
        }

        asynchronous: true
        active: quantity > 0
    }

    Component{
        id: _iconBadge

        BadgeNumber{
            quantity: _badge.quantity
            maxQuantity: _badge.maxQuantity
            pixelSize: _icon.height * 0.6
            accent: _badge.accent
        }
    }

    Component{
        id: _iconDot

        BadgeDot{
            pixelSize: _icon.height * 0.42
            accent: _badge.accent
        }
    }
}
