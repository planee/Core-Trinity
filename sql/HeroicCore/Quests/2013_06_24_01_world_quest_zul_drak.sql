-- DB/Quest: Fix: Wooly Justice (12707) | by Trista & ZxBiohazardZx

-- Add SAI for Enraged Mammoth
SET @Medallion := 52596;
SET @Mammoth :=   28851;
SET @Trample :=   52603;
SET @TAura :=     52607;
SET @Desciple :=  28861;
SET @Credit :=    28876;
UPDATE `creature_template` SET `AIName`='SmartAI',`spell1`=52601,`spell2`=52603 WHERE `entry`=@Mammoth;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Mammoth AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Mammoth,0,0,0,8,0,100,0,@Medallion,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Enraged Mammoth - On hit by spell from medallion - Change faction to friendly'),
(@Mammoth,0,1,0,1,0,100,0,10000,10000,10000,10000,2,1924,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Enraged Mammoth - On OOC for 10 sec - Change faction to back to normal'),
(@Mammoth,0,1,0,1,0,100,0,10000,10000,10000,10000,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Enraged Mammoth - On OOC for 10 sec - DESPAWN');
-- Add SAI for Mam'toth desciple
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@Desciple;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Desciple AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Desciple,0,0,0,6,0,100,0,0,0,0,0,33,@Credit,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Mam''toth desciple - On death - Give credit to invoker, if Tampered'),
(@Desciple,0,1,0,25,0,100,0,0,0,0,0,28,@TAura,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Mam''toth desciple - On reset - Remove aura from trample');
-- Add conditions for spell Medallion of Mam'toth
DELETE FROM `conditions` WHERE `SourceEntry`=@Medallion AND `SourceTypeOrReferenceId`=17;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(17,0,@Medallion,0,0,31,1,3,@Mammoth,0,0,0,'', 'Medallion of Mam''toth can hit only Enraged Mammoths');
-- Add conditions for spell Trample
DELETE FROM `conditions` WHERE `SourceEntry`=@Trample AND `SourceTypeOrReferenceId`=13;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(13,1,@Trample,0,0,31,0,3,@Desciple,0,0,0,'', 'Trample effect 1 can hit only hit Desciple of Mam''toth'),
(13,2,@Trample,0,0,31,0,3,@Desciple,0,0,0,'', 'Trample effect 2 can hit only hit Desciple of Mam''toth');
-- Add conditions for smart_event 0 of Mam'toth desciple
DELETE FROM `conditions` WHERE `SourceEntry`=@Desciple AND `SourceTypeOrReferenceId`=22;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(22,1,@Desciple,0,0,1,1,@TAura,0,0,0,0,'', 'Mam''toth desciple 1st event is valid only, if has Tampered aura credit');
-- Add conditions for spell Trample Aura
DELETE FROM `conditions` WHERE `SourceEntry`=@TAura AND `SourceTypeOrReferenceId`=13;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(13,1,@TAura,0,0,31,0,3,@Desciple,0,0,0,'', 'TAura effect can hit only Desciple of Mam''toth');
