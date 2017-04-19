CREATE TABLE [dbo].[PresupFC]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_PspFC] [char] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[NroCta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ene] [numeric] (13, 2) NULL,
[Ene_ME] [numeric] (13, 2) NULL,
[Feb] [numeric] (13, 2) NULL,
[Feb_ME] [numeric] (13, 2) NULL,
[Mar] [numeric] (13, 2) NULL,
[Mar_ME] [numeric] (13, 2) NULL,
[Abr] [numeric] (13, 2) NULL,
[Abr_ME] [numeric] (13, 2) NULL,
[May] [numeric] (13, 2) NULL,
[May_ME] [numeric] (13, 2) NULL,
[Jun] [numeric] (13, 2) NULL,
[Jun_ME] [numeric] (13, 2) NULL,
[Jul] [numeric] (13, 2) NULL,
[Jul_ME] [numeric] (13, 2) NULL,
[Ago] [numeric] (13, 2) NULL,
[Ago_ME] [numeric] (13, 2) NULL,
[Sep] [numeric] (13, 2) NULL,
[Sep_ME] [numeric] (13, 2) NULL,
[Oct] [numeric] (13, 2) NULL,
[Oct_ME] [numeric] (13, 2) NULL,
[Nov] [numeric] (13, 2) NULL,
[Nov_ME] [numeric] (13, 2) NULL,
[Dic] [numeric] (13, 2) NULL,
[Dic_ME] [numeric] (13, 2) NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PresupFC] ADD CONSTRAINT [PK_PresupFC] PRIMARY KEY CLUSTERED  ([RucE], [Cd_PspFC]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Presup. Flujo de Caja', 'SCHEMA', N'dbo', 'TABLE', N'PresupFC', 'COLUMN', N'Cd_PspFC'
GO
