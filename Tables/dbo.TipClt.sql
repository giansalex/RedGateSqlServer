CREATE TABLE [dbo].[TipClt]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TClt] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipClt] ADD CONSTRAINT [PK_TipClt] PRIMARY KEY CLUSTERED  ([RucE], [Cd_TClt]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Tipo Cliente', 'SCHEMA', N'dbo', 'TABLE', N'TipClt', 'COLUMN', N'Cd_TClt'
GO
