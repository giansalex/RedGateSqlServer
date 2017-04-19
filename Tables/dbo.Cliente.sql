CREATE TABLE [dbo].[Cliente]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Aux] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cliente] ADD CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Aux]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cliente] WITH NOCHECK ADD CONSTRAINT [FK_Cliente_Auxiliar] FOREIGN KEY ([RucE], [Cd_Aux]) REFERENCES [dbo].[Auxiliar] ([RucE], [Cd_Aux])
GO
