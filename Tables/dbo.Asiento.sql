CREATE TABLE [dbo].[Asiento]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [varchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cta] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CtaME] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IC_JDCtaPA] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IC_CaAb] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IN_TipoCta] [int] NULL,
[Cd_IV] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Porc] [numeric] (5, 2) NULL,
[Fmla] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FmlaUsu] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[IC_PFI] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Glosa] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[GlosaUsu] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[IC_VFG] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[IC_JDCC] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Aux] [bit] NULL,
[IB_EsDes] [bit] NULL,
[IB_JalaAmr] [bit] NULL,
[Cd_IA] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IC_ES] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TM] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Asiento] ADD CONSTRAINT [PK_Asiento] PRIMARY KEY CLUSTERED  ([RucE], [Cd_MIS], [Ejer], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Asiento] ADD CONSTRAINT [FK_Asiento_IndicadorValor] FOREIGN KEY ([Cd_IV], [Cd_TM]) REFERENCES [dbo].[IndicadorValor] ([Cd_IV], [Cd_TM])
GO
ALTER TABLE [dbo].[Asiento] WITH NOCHECK ADD CONSTRAINT [FK_Asiento_MtvoIngSal1] FOREIGN KEY ([RucE], [Cd_MIS]) REFERENCES [dbo].[MtvoIngSal] ([RucE], [Cd_MIS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador afecto solo para cabeceras', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'Cd_IA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Tipo Movimiento', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'Cd_TM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cta Moneda Extrangera', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'CtaME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formula', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'Fmla'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formula que ve el usuario', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'FmlaUsu'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formula glosa que ve el usuario', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'GlosaUsu'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Jala Aux', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IB_Aux'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la cuenta es de Destino', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IB_EsDes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Jala Amarre', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IB_JalaAmr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IC_Jala Define CCostos ( J:Jala, D: Def )', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IC_JDCC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IC_Jala Define Cta ( D: Def, P: JalaDeProd, A: JalaDeAuxiliar )', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IC_JDCtaPA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IC_Porcentaje_Formula Importe ( P:Porcentaje, F: Formula )', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IC_PFI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IC_Valor_Formula Glosa ( V:Valor, F: Formula )', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IC_VFG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1: NroCta1, 2: NroCta2, ....', 'SCHEMA', N'dbo', 'TABLE', N'Asiento', 'COLUMN', N'IN_TipoCta'
GO
