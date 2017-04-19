CREATE TABLE [dbo].[ComisionGrupCte]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CGC] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComisionGrupCte] ADD CONSTRAINT [PK_ComisionGrupCte] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CGC]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Cliente', 'SCHEMA', N'dbo', 'TABLE', N'ComisionGrupCte', 'COLUMN', N'Cd_CGC'
GO
