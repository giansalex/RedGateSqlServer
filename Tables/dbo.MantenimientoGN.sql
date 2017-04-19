CREATE TABLE [dbo].[MantenimientoGN]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mnt] [char] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Codigo] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MantenimientoGN] ADD CONSTRAINT [PK_MantenimientoGN] PRIMARY KEY CLUSTERED  ([RucE], [Cd_TM], [Cd_Mnt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MantenimientoGN] ADD CONSTRAINT [FK_MantenimientoGN_TipMant] FOREIGN KEY ([RucE], [Cd_TM]) REFERENCES [dbo].[TipMant] ([RucE], [Cd_TM])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Alternativo', 'SCHEMA', N'dbo', 'TABLE', N'MantenimientoGN', 'COLUMN', N'Codigo'
GO
