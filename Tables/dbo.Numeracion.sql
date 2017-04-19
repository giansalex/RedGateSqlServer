CREATE TABLE [dbo].[Numeracion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Num] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Sr] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Desde] [int] NOT NULL,
[Hasta] [int] NOT NULL,
[NroAutSunat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Numeracion] ADD CONSTRAINT [PK_Numeracion] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Num]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Numeracion] ADD CONSTRAINT [FK_Numeracion_Serie] FOREIGN KEY ([RucE], [Cd_Sr]) REFERENCES [dbo].[Serie] ([RucE], [Cd_Sr])
GO
