#!/bin/sh


curl --form "file=@big_buck_bunny.mp4" --form "file=@Doctorwho_50th-anniversary-thumbnail_01.jpg" --form programme='{"programme":{"id":"id","title":"America Decides","synopsis":"Coverage of the results of the US Presidential Election with Robin Lustig and Claire Bolderson in Washington.", "genres":["News"],"media":"md","image":"img","views":0,"popularity":0,"start-date":"2015-02-19T14:30:00.000Z","end-date":"2015-03-20T15:55:00.000Z"}}'  -X POST "http://localhost:8080/marklogic-tv/api/admin/programmes"

curl --form "file=@mov_bbb.mp4" --form "file=@football_match_18.jpg" --form programme='{"programme":{"id":"id","title":"Chelsea Clinch League Cup","synopsis":"Caroline Barker reacts to Chelsea Cup win over Tottenham Hotspur with former Spurs players with Jermaine Jenas and Bradley Allen. We will also hear from Jose Mourinho after he claimed his first trophy since returning for his second spell as Chelsea manager. John Terry and Diego Costa did the damage either side of the interval as Spurs hopes of repeating their success over Chelsea in this competition seven years ago never got off the ground. The win gave Mourinho his first silverware since La Liga success with Real Madrid in 2012 and Chelsea their first since the Europa League final victory against Benfica in Amsterdam a year later. Despite a career laden with trophies, Mourinho claimed this was the most important final of his time in the game. This Clip is from Sportsworld on Sunday 01 March 2015.", "genres":["Sport"],"media":"md","image":"img","views":0,"popularity":0,"start-date":"2015-03-19T14:30:00.000Z","end-date":"2015-03-20T15:55:00.000Z"}}'  -X POST "http://localhost:8080/marklogic-tv/api/admin/programmes"

curl --form "file=@big_buck_bunny.mp4" --form "file=@Doctorwho_50th-anniversary_thumbnail_02.jpg" --form programme='{"programme":{"id":"id","title":"Doctor Who : The Caretaker","synopsis":"When terrifying events threaten Coal Hill School, the Doctor decides to go undercover. The Skovox Blitzer is ready to destroy all humanity - and worse, any second now, Danny Pink and the Doctor are going to meet.", "genres":["Drama"],"media":"md","image":"img","views":0,"popularity":0,"start-date":"2015-02-19T14:30:00.000Z","end-date":"2015-03-20T15:55:00.000Z"}}'  -X POST "http://localhost:8080/marklogic-tv/api/admin/programmes"
