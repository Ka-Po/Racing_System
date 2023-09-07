# Racing_System
godot_Car_Game_core_part:Racing_System
（用Godot4.1版本）

檔內有5個場境：
1.選單場境
2.Loading畫面
-- --
3.計時完結場境
4.汔車控制器場境
5.兢速系統
********************

選單場境功能：
1.所有場境的改變，都是用掛載新節點到根目錄的方法，
而不是轉換場境。
2.場境的改變，首先會載入Loading畫面。
3.背景音樂在場境改變時，音樂會淡出淡入。
4.計時完結場境內，有暫停選單，當離開主選單及Loading畫面之後，
要先啟動啟動開始遊戲，才可以暫停

計時完結場境，有三個遊戲狀態：
1.預備開啟遊戲：prePlay
2.遊戲中：Playing
3.結束：endPlay
只有第2個狀態可以暫停，而第2及第3的狀態可以回到主選單！

汔車控制器場境：
有一個最簡單的汔車程式，
及設定了光源與背景顏色。
它有prePlay及Playing的遊戲狀態！

兢速系統，模仿汔車比賽的情況：
初始化：首先隨機選車位，及隨機選Ai汔車，然後將汔車放到場境上。
排位：CheckPoint會與所有汔車計算距離，而這些值會經過一條[算式]運算後，將汔車排名。

假如，將以上的汔車控制器，另外加上導航功能，
整合到兢速系統，就可以完成一個兢速遊戲。
