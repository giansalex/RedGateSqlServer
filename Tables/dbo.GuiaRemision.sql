CREATE TABLE [dbo].[GuiaRemision]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSre] [varchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroGR] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecEmi] [smalldatetime] NOT NULL,
[FecIniTras] [smalldatetime] NULL,
[FecFinTras] [smalldatetime] NULL,
[PtoPartida] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TO] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Tra] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[DescripTra] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[PesoTotalKg] [numeric] (18, 3) NULL,
[AutorizadoPor] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[IC_ES] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Anulado] [bit] NULL,
[IB_Impreso] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GuiaRemision] ADD CONSTRAINT [PK_GuiaRemision] PRIMARY KEY CLUSTERED  ([RucE], [Cd_GR]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GuiaRemision] ADD CONSTRAINT [IX_RG_Restriccion__Ruc_TD_NroSre_NroGR] UNIQUE NONCLUSTERED  ([RucE], [Cd_TD], [NroSre], [NroGR]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GuiaRemision] WITH NOCHECK ADD CONSTRAINT [FK_GuiaRemision_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[GuiaRemision] WITH NOCHECK ADD CONSTRAINT [FK_GuiaRemision_TipoOperacion] FOREIGN KEY ([Cd_TO]) REFERENCES [dbo].[TipoOperacion] ([Cd_TO])
GO
ALTER TABLE [dbo].[GuiaRemision] WITH NOCHECK ADD CONSTRAINT [FK_GuiaRemision_Transportista] FOREIGN KEY ([RucE], [Cd_Tra]) REFERENCES [dbo].[Transportista] ([RucE], [Cd_Tra])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'solo si no hay ni un GuiaXVenta', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_Clt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'GR00000001', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_GR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'solo si no hay ni un GuiaxCompra', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_Prv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Operacion', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_TO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Transportista', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'Cd_Tra'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para Trans. no propios', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'DescripTra'
GO
EXEC sp_addextendedproperty N'MS_Description', N'E:Entrada / S:Salida', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'IC_ES'
GO
EXEC sp_addextendedproperty N'MS_Description', N'000384', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'NroSre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Peso Total en Kilogramos', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemision', 'COLUMN', N'PesoTotalKg'
GO
