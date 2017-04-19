CREATE TABLE [dbo].[PersonaRef]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Per] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NDoc] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ApPat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ApMat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Nom] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vin] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PersonaRef] ADD CONSTRAINT [PK_PersonaRef] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Clt], [Cd_Per]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PersonaRef] ADD CONSTRAINT [FK_PersonaRef_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[PersonaRef] WITH NOCHECK ADD CONSTRAINT [FK_PersonaRef_Vinculo] FOREIGN KEY ([RucE], [Cd_Vin]) REFERENCES [dbo].[Vinculo] ([RucE], [Cd_Vin])
GO
