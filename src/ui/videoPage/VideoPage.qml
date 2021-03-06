﻿import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/player/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/components/comment/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item{
    id: root

    function open(js){
        if(undefined === js.vid){
            AcService.getVideoByAc(js.contentId, function(res){
                    res.contentId = res.dougaId
                    res.contentType = 2
                    res.vid = res.videoList[0].id
                    openPrivate(res)
                })
        }else{
            openPrivate(js)
        }
    }

    function back(){
        stop()
    }

    property var param
    function openPrivate(js){
        player.start(js)
        detail.open(js)
        param = js
        btnCmt.visible = true
    }

    function stop() {
        player.stop()
        comment.clear()
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        Column {
            width: root.width-30
            Item {
                id: playerParent
                anchors.left: parent.left
                anchors.right: parent.right
                height: root.height-140//露出up头像
                AcPlayer {
                    id: player
                    anchors.fill: parent
                    normalParent: playerParent
                    onVideoReady: {
                        busyBox.running = false
                    }
                    onVideoEnded: {
                        detail.nextPart()
                    }
                }
            }

            VideoDetail {
                id: detail
                anchors.left: parent.left
                anchors.right: parent.right
                onChangeVideoPart: {
                    busyBox.running = true
                    player.changePart(vInfo)
                }
            }

            CommentList {
                id: comment
                visible: !btnCmt.visible
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }

    RoundButton {
        id: btnGoTop
        icon.name: AppIcons.mdi_arrow_up_thick
        size: 40
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        visible: scroll.ScrollBar.vertical.position>0.2
        onClicked: {
            scroll.ScrollBar.vertical.position = 0
        }
    }
    RoundButton {
        id: btnCmt
        anchors.bottom: btnGoTop.top
        anchors.bottomMargin: 5
        anchors.horizontalCenter: btnGoTop.horizontalCenter
        icon.name: AppIcons.mdi_comment_processing_outline
        size: 40
        tooltip: qsTr("show comment")
        onClicked: {
            visible = false
            comment.open(param)
        }
    }
    Component.onCompleted: {
        console.log("VideoPage completed")
        var d=new Date();
        console.log(FUN.fmtTime(d, "hh:mm:ss"))
    }
}
