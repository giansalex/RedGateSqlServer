CREATE TABLE [dbo].[Periodo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[P00] [bit] NOT NULL CONSTRAINT [DF_Periodo_P00] DEFAULT ((0)),
[P01] [bit] NOT NULL CONSTRAINT [DF_Periodo_P01] DEFAULT ((0)),
[P02] [bit] NOT NULL CONSTRAINT [DF_Periodo_P02] DEFAULT ((0)),
[P03] [bit] NOT NULL CONSTRAINT [DF_Periodo_P03] DEFAULT ((0)),
[P04] [bit] NOT NULL CONSTRAINT [DF_Periodo_P04] DEFAULT ((0)),
[P05] [bit] NOT NULL CONSTRAINT [DF_Periodo_P05] DEFAULT ((0)),
[P06] [bit] NOT NULL CONSTRAINT [DF_Periodo_P06] DEFAULT ((0)),
[P07] [bit] NOT NULL CONSTRAINT [DF_Periodo_P07] DEFAULT ((0)),
[P08] [bit] NOT NULL CONSTRAINT [DF_Periodo_P08] DEFAULT ((0)),
[P09] [bit] NOT NULL CONSTRAINT [DF_Periodo_P09] DEFAULT ((0)),
[P10] [bit] NOT NULL CONSTRAINT [DF_Periodo_P10] DEFAULT ((0)),
[P11] [bit] NOT NULL CONSTRAINT [DF_Periodo_P11] DEFAULT ((0)),
[P12] [bit] NOT NULL CONSTRAINT [DF_Periodo_P12] DEFAULT ((0)),
[P13] [bit] NOT NULL CONSTRAINT [DF_Periodo_P13] DEFAULT ((0)),
[P14] [bit] NOT NULL CONSTRAINT [DF_Periodo_P14] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Periodo] ADD CONSTRAINT [PK_Periodo] PRIMARY KEY CLUSTERED  ([RucE], [Ejer]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Periodo] ADD CONSTRAINT [FK_Periodo_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
