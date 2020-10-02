﻿import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Rectangle {
    property var feedInfo
    property real cardMargin: 5
    id: control
    width: 300
    implicitHeight: col.implicitHeight+2*cardMargin
    color: AppStyle.secondBkgroundColor

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        //anchors.bottom: parent.bottom
        anchors.margins: cardMargin
        anchors.topMargin: cardMargin+4
        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            height: 38

            Avatar {
                id: imgAvatar
                size: 32
                avatarUrl: feedInfo.userInfo.headUrl
                userId: feedInfo.userInfo.id
            }

            Column {
                spacing: 2
                anchors.verticalCenter: imgAvatar.verticalCenter
                anchors.left: imgAvatar.right
                anchors.leftMargin: 10
                TextArea {
                    text: feedInfo.user.userName
                    padding: 0
                    selectByMouse: true
                    readOnly: true
                    font.weight: Font.Bold
                    font.pixelSize: AppStyle.font_large
                    font.family: AppStyle.fontNameMain
                }
                Label {
                    text: feedInfo.time + " " + qsTr("%1 viewed").arg(feedInfo.viewCount)
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }
        }

        TextArea {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            selectByMouse: true
            readOnly: true
            wrapMode: Text.WordWrap
            font.weight: Font.Normal
            font.pixelSize: AppStyle.font_normal
            font.family: AppStyle.fontNameMain
            text: feedInfo.moment?feedInfo.moment.text:
                                       feedInfo.articleBody?feedInfo.articleBody:
                                                                 feedInfo.caption?feedInfo.caption:
                                                                                       feedInfo.articleTitle
        }

        Loader {
            id: ldMedia
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4

        }

        Row {
            id: rowBtns
            spacing: 8
            anchors.left: parent.left
            anchors.right: parent.right
            RoundBtnWithText {//评论
                id: btnComment
                text: feedInfo.commentCount
                icon: "qrc:/assets/img/common/cmt0.png"
                iconChecked: "qrc:/assets/img/common/cmt1.png"
                onClicked: {
                    console.log(customChecked?"btnComment":"btnComment")
                }
            }
            RoundBtnWithText {//投蕉
                id: btnBanana
                text: feedInfo.bananaCount
                customChecked: feedInfo.isThrowBanana
                enabled: !customChecked
                icon: "qrc:/assets/img/common/banana0.png"
                iconChecked: "qrc:/assets/img/common/banana1.png"
                property var componentBanana: null
                onClicked: {
                    customChecked = true
                    AcService.banana(acID, contentType, 1, function(res){
                    })
                }
            }
            RoundBtnWithText {
                id: btnLike
                customChecked: feedInfo.isLike
                enabled: !customChecked
                icon: "qrc:/assets/img/common/like0.png"
                iconChecked: "qrc:/assets/img/common/like1.png"
            }
        }
    }

    Component.onCompleted: {
        if(feedInfo.resourceType === 2){
            ldMedia.setSource("VideoCard.qml",
                              {"infoJs": feedInfo.detail})
        }
    }

}