CREATE TABLE [dbo].[Liquidacion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Liq] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL CONSTRAINT [DF_CajaChica_Cd_Com] DEFAULT (N'Codigo Compra'),
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FechaAper] [datetime] NULL,
[FechaCierre] [datetime] NULL,
[UsuAper] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecAper] [datetime] NULL,
[UsuCierre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecCierre] [datetime] NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[MtoAnt] [decimal] (18, 3) NULL,
[MtoAsig] [decimal] (18, 3) NULL,
[MtoAper] [decimal] (18, 3) NULL,
[MtoCierre] [decimal] (18, 3) NULL,
[MtoAnt_ME] [decimal] (18, 3) NULL,
[MtoAsig_ME] [decimal] (18, 3) NULL,
[MtoAper_ME] [decimal] (18, 3) NULL,
[MtoCierre_ME] [decimal] (18, 3) NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Liquidacion] ADD CONSTRAINT [PK_CajaChica] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Liq]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Liquidacion', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'Liquidacion', 'COLUMN', N'Cd_Liq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Liquidacion', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Liquidacion', 'COLUMN', N'Cd_SS'
GO
