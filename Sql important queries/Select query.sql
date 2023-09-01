/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[Description]
  FROM [SportNet].[dbo].[Conversations]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UserID]
      ,[Username]
      ,[Password]
      ,[Salt]
  FROM [SportNet].[dbo].[UsersCredentials]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UserID]
      ,[ConversationID]
      ,[JoinedDatetime]
      ,[LeftDatetime]
  FROM [SportNet].[dbo].ConversationMembers

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[UserId]
      ,[FriendId]
  FROM [SportNet].[dbo].[Friendship]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[Email]
      ,[Firstname]
      ,[Lastname]
  FROM [SportNet].[dbo].[Users]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[FromUser]
      ,[ToUser]
      ,[Text]
      ,[Datetime]
      ,[ConversationID]
  FROM [SportNet].[dbo].[Messages]
