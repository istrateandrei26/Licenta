USE SportNet;

SELECT CONCAT(U.Firstname,' ', U.Lastname) AS 'From', CONCAT(UU.Firstname,' ', UU.Lastname) as 'To', Fr.Accepted as 'Accepted', U.Id as 'FromID', FR.Id
FROM FriendRequests AS FR
INNER JOIN Users AS U
ON FR.FromUserId = U.Id
INNER JOIN USERS AS UU
ON FR.ToUserId = UU.Id


UPDATE FriendRequests
SET Accepted = 0
WHERE Id = 2

SELECT *
FROM Conversations

SELECT CONCAT(U.Firstname,' ', U.Lastname) AS 'From', CONCAT(UU.Firstname,' ', UU.Lastname), U.Id, UU.Id, F.Id
FROM Friendship AS F
INNER JOIN Users AS U
ON F.UserId = U.Id
INNER JOIN USERS AS UU
ON F.FriendId = UU.Id


SELECT *
FROM ConversationMembers
WHERE UserID = 1041

SELECT * FROM Messages


--DELETE 
--FROM Friendship
--WHERE Id = 1033


SELECT C.Description, C.IsGroup, C.Id
FROM ConversationMembers AS CM
INNER JOIN Conversations AS C
ON CM.ConversationID = C.Id
WHERE UserID = 1042


SELECT *
FROM ConversationMembers
WHERE ConversationID = 4031


--DELETE 
--FROM Messages WHERE
--ConversationID = 4039

--DELETE 
--FROM ConversationMembers
--WHERE ConversationID = 4039


--DELETE 
--FROM Conversations
--WHERE Id = 4039

--UPDATE
--Messages
--SET Content = 'Super, abia astept!!'
--WHERE Id = 5350


SELECT * 
FROM Messages


SELECT Id, Content, FromUser, ToUser
FROM Messages
WHERE ConversationID = 2


SELECT * 
FROM MessageReactions AS MR
INNER JOIN Messages AS M
ON MR.MessageId = M.Id
INNER JOIN Conversations AS C
ON M.ConversationID = C.Id


SELECT *
FROM Users
