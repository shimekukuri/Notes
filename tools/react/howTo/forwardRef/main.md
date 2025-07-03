# React How To Forward Ref

## Abstract
```typescript
'use client'
import React, { ChangeEvent, forwardRef, useState } from 'react';
import classes from './GenericSlider.module.scss';

type propOveride = "onChange" | "onPointerUp";

export interface GenericSliderProps extends Omit<React.ComponentProps<"input">, propOveride> {
    onChange?: (arg0: number) => void,
    onPointerUp?: (arg0: number) => void;
    label?: (arg0: number) => React.JSX.Element;
}

export const GenericSlider = forwardRef<HTMLInputElement, GenericSliderProps>(({
    min = 0,
    max = 100,
    step = 1,
    value,
    onChange,
    onPointerUp,
    label,
    ...rest
}: GenericSliderProps, ref) => {
    const _min = castToInt(min);
    const _max = castToInt(max);
    const _step = castToInt(step);
    const [_value, setValue] = useState<number>(castToInt(value, _min));

    const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
        setValue(castToInt(e.target.value));
    };

    return (
        <div className={classes.slider}>
            <input
                {...rest}
                type="range"
                min={_min}
                max={_max}
                step={_step}
                value={_value}
                onPointerUp={() => onPointerUp && onPointerUp(_value)}
                onChange={(e) => {
                    handleChange(e);
                    onChange && onChange(_value);
                }}
                ref={ref}
            />
            <div className={classes.fill}>
                <div
                    className={classes.upper}
                    style={{
                        transform: `scaleX(${(parseFloat(`${_value}`.replace(/,/g, '')) - _min) / (_max - _min) || 0}`
                    }}
                ></div>
                <div className={classes.lower} />
            </div>
            {label ?
                <div className={classes.labelContainer}>
                    {label(_value)}
                </div>
                : <></>}
        </div>
    );
});

GenericSlider.displayName = 'GenericSlider';

const castToInt = (x: any, y?: number) => {
    switch (typeof x) {
        case 'string': {
            return Number.parseInt(x);
        }
        case 'number': {
            return x
        }
        case 'bigint': {
            if (x <= Number.MAX_SAFE_INTEGER) {
                return Number.parseInt(`${x}`);
            } else {
                return Number.MAX_SAFE_INTEGER;
            }
        }
        case 'boolean': {
            if (x) {
                return 1;
            } else {
                return 0;
            }
        }
        case 'symbol': {
            return y ? y : 0;
        }
        case 'undefined': {
            return y ? y : 0;
        }
        case 'object': {
            return y ? y : 0;
        }
        case 'function': {
            return y ? y : 0;
        }
    }

}

```

## Directory

## Useful Links

## Tags
[[react-concept-ref]]
[[react-concepts-forward-ref]]
