# React Design Patterns Render Prop

## Abstract
The idea of this design pattern is that we have a prop that is a list (array of elements)

```typescript
import { Dispatch, SetStateAction, useContext, useEffect } from "react";
import { FieldValues, Path, UseFormReturn, useForm } from "react-hook-form";
import { SharedFormValues } from "./TaskFormTypes";
import {
	FormProgress,
	useMultiFormProgress,
} from "./TaskFormMasterSubmitProvider";
import { useGetTaskTypesQuery } from "../../api/endpoints";
import { TaskTypeLookup } from "../../Types";

export function GenericForm<T extends FieldValues>({
	chilrenWithForm,
	subType,
	onSubmit,
	inputStyles,
	taskTypeLookup,
	formContainerStyles,
}: GenericFormInt<T & GenericFormFields>) {
	const { form } = useMultiFormProgress<T & GenericFormFields>({
		onSubmit,
		subType,
	});

	let subtypeName = "";

	for (let x of taskTypeLookup ?? []) {
		for (let y of x.taskSubTypes) {
			if (y.id === subType) {
				subtypeName = y.name;
			}
		}
	}

	return (
		<>
			<h3>{subtypeName}</h3>
			<form className={`${formContainerStyles ? formContainerStyles : ""}`}>
				<input
					{...form.register("name" as Path<T & GenericFormFields>)}
					className={`${inputStyles ? inputStyles : ""}`}
				/>
				{form.formState.errors.name?.message ? (
					<p>{form.formState.errors.name.message.toString()}</p>
				) : (
					<></>
				)}
				<input
					{...form.register("dueDate" as Path<T & GenericFormFields>)}
					className={`${inputStyles ? inputStyles : ""}`}
				/>
				{form.formState.errors.dueDate?.message ? (
					<p>{form.formState.errors.dueDate.toString()}</p>
				) : (
					<></>
				)}
				<input
					{...form.register("assignedTo" as Path<T & GenericFormFields>)}
					className={`${inputStyles ? inputStyles : ""}`}
				/>
				{form.formState.errors.assignedTo?.message ? (
					<p>{form.formState.errors.assignedTo.toString()}</p>
				) : (
					<></>
				)}
				<input
					{...form.register("asset" as Path<T & GenericFormFields>)}
					className={`${inputStyles ? inputStyles : ""}`}
				/>
				{chilrenWithForm ? chilrenWithForm(form) : <></>}
			</form>
		</>
	);
}

export interface GenericFormInt<T extends FieldValues> {
	chilrenWithForm?: (arg0: UseFormReturn<T, any, T>) => React.ReactNode;
	inputStyles?: string;
	formContainerStyles?: string;
	sharedForm: UseFormReturn<SharedFormValues, any, SharedFormValues>;
	subType: string;
	taskTypeLookup: TaskTypeLookup[];
	onSubmit: (params: {
		formValues: T & GenericFormFields;
		setProgress: Dispatch<SetStateAction<FormProgress>>;
	}) => Promise<any | void>;
}

export interface GenericFormFields {
	name: string;
	dueDate: string | null;
	assignedTo: string;
	asset: string;
}
```

```typescript
import { UseFormReturn } from "react-hook-form";
import { SharedFormValues } from "./TaskFormTypes";
import styles from "./TaskForm.index.module.scss";
import { GenericForm } from "./GenericForm";
import { TaskTypeLookup } from "../../Types";

interface MultiFormControllerInt {
	sharedForm: UseFormReturn<SharedFormValues, any, SharedFormValues>;
	taskTypeLookup: TaskTypeLookup[];
}

export function MultiFormController({
	sharedForm,
	taskTypeLookup,
}: MultiFormControllerInt) {
	const { subType } = sharedForm.watch();

	return (
		<div className={`${styles.multiFormControllerContainer}`}>
			{subType?.map(
				(x) =>
					(
						<GenericForm<{ iAmDynmicallyAdded: string }>
							sharedForm={sharedForm}
							taskTypeLookup={taskTypeLookup}
							subType={x}
							key={x}
							onSubmit={async ({ setProgress, formValues }) => {
								console.log(formValues);
							}}
							chilrenWithForm={(x) => (
								<>
									<input {...x.register("iAmDynmicallyAdded")} />
									{x.formState.errors.iAmDynmicallyAdded}
								</>
							)}
						/>
					) ?? <></>
			)}
		</div>
	);
}

/**
async function exampleGenericFormOnSubmitHandler({
    setProgress,
    formValues,
}: GenericFormSubmitHandlerProps<{ iAmDynmicallyAdded: string }>) {
    console.log("formValues", formValues);
    setProgress((x) => {
        return {
            ...x, [key]: {
                isCompleted,
                subType,
                progress,
                isSubmitting
            }
        }
    });
}
**/

```

## Directory

## Useful Links

## Tags
