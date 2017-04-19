CREATE TABLE [dbo].[Vinculo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vin] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vinculo] ADD CONSTRAINT [PK_Vinculo] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Vin]) ON [PRIMARY]
GO
