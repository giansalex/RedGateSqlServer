CREATE TABLE [dbo].[ReporteFinancieroDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_REF] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Rub] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Predecesor] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[RefPorc] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Nivel] [smallint] NOT NULL,
[Formula] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IB_esTitulo] [bit] NULL,
[IB_verPlanCta] [bit] NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReporteFinancieroDet] ADD CONSTRAINT [PK_RubrosReporte] PRIMARY KEY CLUSTERED  ([RucE], [Ejer], [Cd_REF], [Cd_Rub]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReporteFinancieroDet] ADD CONSTRAINT [FK_ReporteFinancieroDet_ReporteFinanciero] FOREIGN KEY ([RucE], [Ejer], [Cd_REF]) REFERENCES [dbo].[ReporteFinanciero] ([RucE], [Ejer], [Cd_REF])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo por cada concepto o rubro del Estado Financiero', 'SCHEMA', N'dbo', 'TABLE', N'ReporteFinancieroDet', 'COLUMN', N'Cd_Rub'
GO
EXEC sp_addextendedproperty N'MS_Description', N'En el caso de que el rubro esta compuesto por opraciones entre otros conceptos', 'SCHEMA', N'dbo', 'TABLE', N'ReporteFinancieroDet', 'COLUMN', N'Formula'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Solo se visualizara como titulo y no realizara ninguna operacion', 'SCHEMA', N'dbo', 'TABLE', N'ReporteFinancieroDet', 'COLUMN', N'IB_esTitulo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Para que se jale en plan de cuentas', 'SCHEMA', N'dbo', 'TABLE', N'ReporteFinancieroDet', 'COLUMN', N'IB_verPlanCta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'La posicion que debe contener el rubro', 'SCHEMA', N'dbo', 'TABLE', N'ReporteFinancieroDet', 'COLUMN', N'Nivel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del concepto o rubro', 'SCHEMA', N'dbo', 'TABLE', N'ReporteFinancieroDet', 'COLUMN', N'Nombre'
GO
