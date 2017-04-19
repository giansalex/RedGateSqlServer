CREATE TABLE [dbo].[Cuota]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_EC] [int] NOT NULL,
[Cd_Cuo] [int] NOT NULL,
[FecED] [smalldatetime] NULL,
[FecVD] [smalldatetime] NULL,
[FecCbr] [smalldatetime] NULL,
[Total] [numeric] (13, 2) NOT NULL CONSTRAINT [DF_Cuota_Total] DEFAULT ((0)),
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Fact] [bit] NOT NULL,
[IB_Cbdo] [bit] NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cuota] ADD CONSTRAINT [PK_Cuota] PRIMARY KEY CLUSTERED  ([RucE], [Cd_EC], [Cd_Cuo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cuota] ADD CONSTRAINT [FK_Cuota_EstadoCta] FOREIGN KEY ([RucE], [Cd_EC]) REFERENCES [dbo].[EstadoCta] ([RucE], [Cd_EC])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha a Cobrar', 'SCHEMA', N'dbo', 'TABLE', N'Cuota', 'COLUMN', N'FecCbr'
GO
