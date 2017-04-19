CREATE TABLE [dbo].[Prod_UM]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Cd_UM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DescripAlt] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Factor] [numeric] (13, 3) NOT NULL,
[PesoKg] [numeric] (18, 3) NULL,
[Volumen] [numeric] (18, 3) NULL,
[EstadoUMP] [bit] NULL,
[IB_UMPPrin] [bit] NULL,
[IC_CL] [char] (1) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Prod_UM] ADD CONSTRAINT [PK_Prod_UM] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Prod], [ID_UMP]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Prod_UM] WITH NOCHECK ADD CONSTRAINT [FK_Prod_UM_Producto21] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[Prod_UM] WITH NOCHECK ADD CONSTRAINT [FK_Prod_UM_UnidadMedida] FOREIGN KEY ([Cd_UM]) REFERENCES [dbo].[UnidadMedida] ([Cd_UM])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador es principal', 'SCHEMA', N'dbo', 'TABLE', N'Prod_UM', 'COLUMN', N'IB_UMPPrin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Peso Aproximado', 'SCHEMA', N'dbo', 'TABLE', N'Prod_UM', 'COLUMN', N'PesoKg'
GO
