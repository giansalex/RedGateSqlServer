CREATE TABLE [dbo].[GRPtoLlegada]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Direc] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[RSocial] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GRPtoLlegada] ADD CONSTRAINT [PK_GRPtoLlegada] PRIMARY KEY CLUSTERED  ([RucE], [Cd_GR], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GRPtoLlegada] WITH NOCHECK ADD CONSTRAINT [FK_GRPtoLlegada_GuiaRemision] FOREIGN KEY ([RucE], [Cd_GR]) REFERENCES [dbo].[GuiaRemision] ([RucE], [Cd_GR])
GO
EXEC sp_addextendedproperty N'MS_Description', N'GR00000001', 'SCHEMA', N'dbo', 'TABLE', N'GRPtoLlegada', 'COLUMN', N'Cd_GR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item x Ruc_GR', 'SCHEMA', N'dbo', 'TABLE', N'GRPtoLlegada', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'NroDoc Factura', 'SCHEMA', N'dbo', 'TABLE', N'GRPtoLlegada', 'COLUMN', N'NroDoc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'GRPtoLlegada', 'COLUMN', N'RSocial'
GO
