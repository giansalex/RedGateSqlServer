CREATE TABLE [dbo].[CfgAutorizacion]
(
[Id_Aut] [int] NOT NULL,
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_DMA] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Tipo] [int] NULL,
[DescripTip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Hab] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgAutorizacion] ADD CONSTRAINT [PK_Autorizacion] PRIMARY KEY CLUSTERED  ([Id_Aut]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgAutorizacion] ADD CONSTRAINT [IX_CfgAutorizacion] UNIQUE NONCLUSTERED  ([RucE], [Cd_DMA], [Tipo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgAutorizacion] WITH NOCHECK ADD CONSTRAINT [FK_CfgAutorizacion_DocMovAuts] FOREIGN KEY ([Cd_DMA]) REFERENCES [dbo].[DocMovAuts] ([Cd_DMA]) ON UPDATE CASCADE
GO
