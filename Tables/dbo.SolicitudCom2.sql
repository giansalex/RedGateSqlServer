CREATE TABLE [dbo].[SolicitudCom2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSCo] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[FecEmi] [smalldatetime] NOT NULL,
[FecEnt] [smalldatetime] NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[FecPag] [smalldatetime] NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (7, 4) NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[ValorTotal] [numeric] (20, 10) NULL,
[DsctoP] [numeric] (5, 2) NULL,
[DsctoI] [numeric] (20, 10) NULL,
[ValorNeto] [numeric] (20, 10) NULL,
[DsctoFnzP] [numeric] (5, 2) NULL,
[DsctoFnzI] [numeric] (20, 10) NULL,
[Bim] [numeric] (20, 10) NULL,
[Igv] [numeric] (20, 10) NULL,
[Total] [numeric] (20, 10) NULL,
[Obs] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[ElaboradoPor] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[FecCrea] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Impreso] [bit] NULL,
[TipAut] [int] NULL,
[IB_EsAut] [bit] NULL,
[IB_Anulado] [bit] NULL,
[IB_Eliminado] [bit] NULL,
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
[CA11] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA16] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[CA17] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[CA18] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[CA19] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[CA20] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[CA21] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA22] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA23] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA24] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA25] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudCom2] ADD CONSTRAINT [PK_SolicitudCom2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SCo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudCom2] ADD CONSTRAINT [FK_SolicitudCom2_Area] FOREIGN KEY ([RucE], [Cd_Area]) REFERENCES [dbo].[Area] ([RucE], [Cd_Area])
GO
ALTER TABLE [dbo].[SolicitudCom2] ADD CONSTRAINT [FK_SolicitudCom2_FormaPC] FOREIGN KEY ([Cd_FPC]) REFERENCES [dbo].[FormaPC] ([Cd_FPC])
GO
ALTER TABLE [dbo].[SolicitudCom2] ADD CONSTRAINT [FK_SolicitudCom2_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
ALTER TABLE [dbo].[SolicitudCom2] ADD CONSTRAINT [FK_SolicitudCom2_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
