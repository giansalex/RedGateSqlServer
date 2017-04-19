CREATE TABLE [dbo].[CfgVenta]
(
[RucE] [char] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_ValCltSNT] [bit] NULL,
[IB_NoPermRegCNV] [bit] NULL,
[DE_IB_GenDE] [bit] NULL,
[DE_IB_EnvSinc] [bit] NULL,
[DE_IB_GuardarArchs] [bit] NULL,
[DE_RutaArchs] [varchar] (256) COLLATE Modern_Spanish_CI_AS NULL,
[DE_NroResol_SNT] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgVenta] ADD CONSTRAINT [PK_CfgVenta] PRIMARY KEY CLUSTERED  ([RucE]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doc. Elect.: Envío Sincrono', 'SCHEMA', N'dbo', 'TABLE', N'CfgVenta', 'COLUMN', N'DE_IB_EnvSinc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doc. Elect.: Generar Documento Electronico', 'SCHEMA', N'dbo', 'TABLE', N'CfgVenta', 'COLUMN', N'DE_IB_GenDE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Guardar Archivos XML Fisicamente', 'SCHEMA', N'dbo', 'TABLE', N'CfgVenta', 'COLUMN', N'DE_IB_GuardarArchs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Resolución SUNAT', 'SCHEMA', N'dbo', 'TABLE', N'CfgVenta', 'COLUMN', N'DE_NroResol_SNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ruta Archivos XML', 'SCHEMA', N'dbo', 'TABLE', N'CfgVenta', 'COLUMN', N'DE_RutaArchs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'No Permitir Registro Cliente No Valido, en ventana de movimientos', 'SCHEMA', N'dbo', 'TABLE', N'CfgVenta', 'COLUMN', N'IB_NoPermRegCNV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valida Cliente con SUNAT', 'SCHEMA', N'dbo', 'TABLE', N'CfgVenta', 'COLUMN', N'IB_ValCltSNT'
GO
