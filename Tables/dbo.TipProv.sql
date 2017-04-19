CREATE TABLE [dbo].[TipProv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TPrv] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipProv] ADD CONSTRAINT [PK_TipProv] PRIMARY KEY CLUSTERED  ([RucE], [Cd_TPrv]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Tipo Proveedor', 'SCHEMA', N'dbo', 'TABLE', N'TipProv', 'COLUMN', N'Cd_TPrv'
GO
