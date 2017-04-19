CREATE TABLE [dbo].[TipDocES]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDES] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipDocES] ADD CONSTRAINT [PK_TipDocES] PRIMARY KEY CLUSTERED  ([RucE], [Cd_TDES]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tip. Doc. Entrada/Salida', 'SCHEMA', N'dbo', 'TABLE', N'TipDocES', 'COLUMN', N'Cd_TDES'
GO
