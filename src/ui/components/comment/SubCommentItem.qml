﻿import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Row {
    id: control
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: 10
    spacing: 20
    //height: 100
    leftPadding: 10
    property var js
    property var editorItemHeight

    signal replyTo(var cmtId, var userName, var editerParent)

    RoundImage {
        id: imgAvatar
        width: 80
        height: width
        source: js.headImgUrl
        onClicked: {
        }
    }

    Component {
        id: cmpGif
        AnimatedImage {
            id: gif
        }
    }

    Component {
        id: cmpImg
        Image {
            id: img
        }
    }

    Column {
        id: col
        width: parent.width-imgAvatar.width-control.spacing

        Row {
            spacing: 8
            Text {
                id: txUserName
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                font.weight: Font.Normal
                text: js.userName
            }
            RectBackLabel {
                height: txUserName.height
                visible: js.isSameCity||js.isUp
                text: js.isUp?qsTr("UP"):qsTr("same city")
            }
            Text {
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                font.weight: Font.Normal
                color: AppStyle.thirdForeColor
                text: qsTr("post time")+" " +js.postDate
            }
        }

        CommentContent {
            id: cmtArea
            anchors.left: parent.left
            anchors.right: parent.right
            replyTo: js.replyTo
            replyToName:js.replyToUserName
            contentText: js.content
        }

        Row {
            spacing: 18
            RoundBtnWithText {
                id: btnLike
                icon: "qrc:/assets/img/common/like0.png"
                iconChecked: "qrc:/assets/img/common/like1.png"
            }
            RoundBtnWithText {
                id: btnReply
                icon: "qrc:/assets/img/common/cmt0.png"
                iconChecked: "qrc:/assets/img/common/cmt1.png"
                enabled: !customChecked
                onClicked: {
                    console.log("reply to:"+js.commentId+js.userName)
                    replyTo(js.commentId, js.userName, cmtEditer)
                    cmtEditer.visible = true
                }
            }
            Text {
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                font.weight: Font.Normal
                color: AppStyle.thirdForeColor
                height: btnLike.height
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Send by") + js.deviceModel
            }
        }

        Rectangle {
            id: cmtEditer
            anchors.left: parent.left
            anchors.right: parent.right
            visible: false
            height: visible?editorItemHeight:0
            color: "transparent"
            onVisibleChanged: {
                if(!visible){
                    btnReply.customChecked = false
                }
            }
        }
    }
}
