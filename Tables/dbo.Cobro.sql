CREATE TABLE [dbo].[Cobro]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ItmCo] [int] NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Itm_BC] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecPag] [smalldatetime] NOT NULL,
[IC_TipPag] [varchar] (1) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CamMda] [numeric] (6, 3) NOT NULL,
[Monto] [numeric] (13, 2) NOT NULL,
[TipOper] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[NroChke] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[FecMdf] [datetime] NULL,
[CbrdoPor] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cobro] ADD CONSTRAINT [PK_Cobro] PRIMARY KEY CLUSTERED  ([RucE], [ItmCo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cobro] WITH NOCHECK ADD CONSTRAINT [FK_Cobro_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
ALTER TABLE [dbo].[Cobro] WITH NOCHECK ADD CONSTRAINT [FK_Cobro_Venta] FOREIGN KEY ([RucE], [Cd_Vta]) REFERENCES [dbo].[Venta] ([RucE], [Cd_Vta])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vendedor o Usuario que cobro la venta', 'SCHEMA', N'dbo', 'TABLE', N'Cobro', 'COLUMN', N'CbrdoPor'
GO
